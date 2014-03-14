Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:60139 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbaCNPwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 11:52:20 -0400
Received: by mail-lb0-f179.google.com with SMTP id p9so1942311lbv.10
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 08:52:18 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <532321D5.4020906@fb.com>
References: <alpine.DEB.2.00.1403111642350.5511@cobra.newdream.net>
	<53231FC8.6040100@fb.com>
	<alpine.DEB.2.00.1403140832510.316@cobra.newdream.net>
	<532321D5.4020906@fb.com>
Date: Fri, 14 Mar 2014 15:52:18 +0000
Message-ID: <CAL3q7H54yHuK9fNWgv-qYEdDNi3s=qNYGp5UUrg0wau_6rX5UA@mail.gmail.com>
Subject: Re: warn at fs/btrfs/extent-tree.c:5748 __btrfs_free_extent+0x9ce/0xa20
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Sage Weil <sage@inktank.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 14, 2014 at 3:35 PM, Josef Bacik <jbacik@fb.com> wrote:
> On 03/14/2014 11:34 AM, Sage Weil wrote:
>>
>> On Fri, 14 Mar 2014, Josef Bacik wrote:
>>>
>>> On 03/11/2014 07:44 PM, Sage Weil wrote:
>>>>
>>>> Hey,
>>>>
>>>> Is this something you guys have seen before?  This is from v3.13-rc2.
>>>>
>>>> kernel: [49432.696440] WARNING: CPU: 3 PID: 26411 at
>>>> /srv/autobuild-ceph/gitbuilder.git/build/fs/btrfs/extent-tree.c:5748
>>>> __btrfs_free_extent+0x9ce/0xa20 [btrfs]()
>>>> kernel: [49432.710128] Modules linked in: arc4(F) md4(F) nls_utf8(F)
>>>> cifs(F) ufs(F) qnx4(F) hfsplus(F) hfs(F) minix(F) ntfs(F) msdos(F) jfs(F)
>>>> xfs(F) reiserfs(F) ext2(F) kvm_intel(F) kvm(F) ib_iser(F) rdma_cm(F)
>>>> ib_cm(F) iw_cm(F) ib_sa(F) ib_mad(F) ib_core(F) ib_addr(F) iscsi_tcp(F)
>>>> libiscsi_tcp(F) libiscsi(F) psmouse(F) ipmi_si(F) serio_raw(F) gpio_ich(F)
>>>> joydev(F) dcdbas(F) i7core_edac(F) edac_core(F) ipmi_msghandler(F)
>>>> mac_hid(F) acpi_power_meter(F) lpc_ich(F) tpm_tis(F) nfsd(F) nfs_acl(F)
>>>> auth_rpcgss(F) scsi_transport_iscsi(F) nfs(F) fscache(F) lockd(F) lp(F)
>>>> sunrpc(F) parport(F) hid_generic(F) usbhid(F) hid(F) btrfs(F) raid6_pq(F)
>>>> mptsas(F) ixgbe(F) mptscsih(F) dca(F) mptbase(F) ptp(F) pps_core(F)
>>>> scsi_transport_sas(F) xor(F) mdio(F) bnx2(F) libcrc32c(F)
>>>> kernel: [49432.777445] CPU: 3 PID: 26411 Comm: ceph-osd Tainted: GF
>>>> I  3.14.0-rc5-ceph-00016-gf31a96a #1
>>>> kernel: [49432.786704] Hardware name: Dell Inc. PowerEdge R410/01V648,
>>>> BIOS 1.6.3 02/07/2011
>>>> kernel: [49432.794223]  0000000000001674 ffff8800bf1cbac8
>>>> ffffffff816e4840 ffff88022726ef90
>>>> kernel: [49432.801700]  0000000000000000 ffff8800bf1cbb08
>>>> ffffffff810524ac a800000000b07e50
>>>> kernel: [49432.809176]  ffff880094e74120 0000000000000000
>>>> 00000000b07c9000 0000000000000000
>>>> kernel: [49432.816653] Call Trace:
>>>> kernel: [49432.819119]  [<ffffffff816e4840>] dump_stack+0x46/0x58
>>>> kernel: [49432.825384]  [<ffffffff810524ac>]
>>>> warn_slowpath_common+0x8c/0xc0
>>>> kernel: [49432.831413]  [<ffffffff810524fa>]
>>>> warn_slowpath_null+0x1a/0x20
>>>> kernel: [49432.837284]  [<ffffffffa010b4be>]
>>>> __btrfs_free_extent+0x9ce/0xa20 [btrfs]
>>>> kernel: [49432.844108]  [<ffffffffa01110b8>]
>>>> __btrfs_run_delayed_refs+0x428/0x11e0 [btrfs]
>>>> kernel: [49432.851465]  [<ffffffffa0109458>] ?
>>>> block_rsv_release_bytes+0x108/0x190 [btrfs]
>>>> kernel: [49432.858823]  [<ffffffffa0114066>]
>>>> btrfs_run_delayed_refs+0x76/0x2a0 [btrfs]
>>>> kernel: [49432.865869]  [<ffffffffa01251ff>]
>>>> __btrfs_end_transaction+0x26f/0x370 [btrfs]
>>>> kernel: [49432.873044]  [<ffffffffa0125330>]
>>>> btrfs_end_transaction+0x10/0x20 [btrfs]
>>>> kernel: [49432.879872]  [<ffffffffa01327de>] btrfs_link+0x13e/0x1d0
>>>> [btrfs]
>>>> kernel: [49432.885903]  [<ffffffff811b7571>] vfs_link+0x1b1/0x270
>>>> kernel: [49432.891060]  [<ffffffff811b8120>] SyS_linkat+0x210/0x2d0
>>>> kernel: [49432.896394]  [<ffffffff811b81fe>] SyS_link+0x1e/0x20
>>>> kernel: [49432.901380]  [<ffffffff816f7cd6>]
>>>> system_call_fastpath+0x1a/0x1f
>>>>
>>>> The full dump is at
>>>>
>>>>
>>>> https://urldefense.proofpoint.com/v1/url?u=http://tracker.ceph.com/issues/7688&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=5Q0Wl4GGvXb3sw11Xy%2FYQnZbcMlzHHsbegI1uoQnEbE%3D%0A&s=f85b1094d776c10386c681a8a7b31e49f0621bf51829b6e7153095f2335a01c0
>>>>
>>>> https://urldefense.proofpoint.com/v1/url?u=http://tracker.ceph.com/attachments/download/1141/kern.log.gz&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=5Q0Wl4GGvXb3sw11Xy%2FYQnZbcMlzHHsbegI1uoQnEbE%3D%0A&s=dff103270aba751a919e566182a4d9482041f972ac72cb12435814ae75cacf14
>>>>
>>>
>>> Filipe's looking at this Sage, you said it happend on v3.13-rc2 but the
>>> kernel line says 3.14.0-rc5, have you had it happen in both places?
>>> Thanks,
>>
>>
>> Whoops, that's my mistake.. it's 3.14-rc5.  The exact commit is it
>> git://github.com/ceph/ceph-client.git, if it matters; it's -rc5 + some
>> ceph patches.
>>
>
> Cool, not worried about what you guys are doing, just wondering if it may be
> related to me screwing around in delayed ref land recently or if you had
> seen it earlier too.  Thanks,

I ran into this a couple times months ago, definitely way before the
recent changes in the ref merging code added in 3.14. I had balance
running with concurrent snapshot creation and deletion at the time,
but unsuccessful so far to trigger it again.

>
> Josef
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
