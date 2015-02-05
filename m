Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32679 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757068AbbBEQRE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Feb 2015 11:17:04 -0500
Date: Thu, 5 Feb 2015 11:16:03 -0500
From: Chris Mason <clm@fb.com>
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, LKP <lkp@01.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        NeilBrown <neilb@suse.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: __might_sleep() warnings on v3.19-rc6
Message-ID: <20150205161603.GA6561@ret.masoncoding.com>
References: <20141028142541.GA19097@wfg-t540p.sh.intel.com>
 <20150201034315.GA20124@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20150201034315.GA20124@wfg-t540p.sh.intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 31, 2015 at 07:43:15PM -0800, Fengguang Wu wrote:
> Hi all,
> 
> I see 2 __might_sleep() warnings on when running LKP tests on
> v3.19-rc6, one related to raid5 and another related to btrfs.
> 
> They might be exposed by this patch.
> FSUse%        Count         Size    Files/sec     App Overhead
> [  101.678419] ------------[ cut here ]------------
> [  101.684612] WARNING: CPU: 4 PID: 2153 at kernel/sched/core.c:7300 __might_sleep+0xbd/0xd0()
> [  101.696412] do not call blocking ops when !TASK_RUNNING; state=2 set at [<ffffffff810b63ff>] prepare_to_wait+0x2f/0x90
> [  101.709259] Modules linked in: ipmi_watchdog btrfs sr_mod cdrom xor raid6_pq sg sd_mod snd_pcm snd_timer snd soundcore pcspkr mgag200 syscopyarea sysfillrect sysimgblt ttm ahci drm_kms_helper libahci drm libata usb_storage i2c_i801 ipmi_si ipmi_msghandler i7core_edac edac_core acpi_cpufreq
> [  101.741823] CPU: 4 PID: 2153 Comm: fs_mark Not tainted 3.19.0-rc6-g26bc420b #1
> [  101.750851] Hardware name: Intel Corporation S5520UR/S5520UR, BIOS S5500.86B.01.00.0050.050620101605 05/06/2010
> [  101.763101]  ffffffff81b75d50 ffff8801dd947c78 ffffffff818a38f0 ffff8801e9c500f8
> [  101.772473]  ffff8801dd947cc8 ffff8801dd947cb8 ffffffff8107260a 0000000000000004
> [  101.781793]  ffffffff81b76780 0000000000000061 0000000000000000 ffff8801e8438000
> [  101.791140] Call Trace:
> [  101.794751]  [<ffffffff818a38f0>] dump_stack+0x4c/0x65
> [  101.801386]  [<ffffffff8107260a>] warn_slowpath_common+0x8a/0xc0
> [  101.809003]  [<ffffffff81072686>] warn_slowpath_fmt+0x46/0x50
> [  101.816335]  [<ffffffff810b63ff>] ? prepare_to_wait+0x2f/0x90
> [  101.823616]  [<ffffffff810b63ff>] ? prepare_to_wait+0x2f/0x90
> [  101.830875]  [<ffffffff8109874d>] __might_sleep+0xbd/0xd0
> [  101.837766]  [<ffffffff818a9364>] mutex_lock+0x24/0x50
> [  101.844399]  [<ffffffffa0285e88>] wait_for_writer+0x68/0xc0 [btrfs]
> [  101.853029]  [<ffffffff810b67e0>] ? wait_woken+0xc0/0xc0
> [  101.859849]  [<ffffffffa028b918>] btrfs_sync_log+0xf8/0xa70 [btrfs]
> [  101.867740]  [<ffffffffa028c7bd>] ? btrfs_log_dentry_safe+0x6d/0x80 [btrfs]
> [  101.876395]  [<ffffffffa02605d2>] btrfs_sync_file+0x2f2/0x330 [btrfs]
> [  101.884375]  [<ffffffff81218101>] do_fsync+0x51/0x80
> [  101.890737]  [<ffffffff81197977>] ? might_fault+0x47/0x50
> [  101.897610]  [<ffffffff812183a0>] SyS_fsync+0x10/0x20
> [  101.904096]  [<ffffffff818ac029>] system_call_fastpath+0x12/0x17
> [  101.911647] ---[ end trace 77681997f1c4e23f ]---
>      1        51200         8192        365.3          2076332

The btrfs one will only trigger when we don't actually schedule:

        while (atomic_read(&root->log_writers)) {
                prepare_to_wait(&root->log_writer_wait,
                                &wait, TASK_UNINTERRUPTIBLE);
                mutex_unlock(&root->log_mutex);
                if (atomic_read(&root->log_writers))
                        schedule();
                mutex_lock(&root->log_mutex);
                finish_wait(&root->log_writer_wait, &wait);
        }

I'll switch things around.

-chris
