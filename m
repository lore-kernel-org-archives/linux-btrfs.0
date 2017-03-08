Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:52050 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933325AbdCHAxQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 19:53:16 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id AFC5EAC012C
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Mar 2017 09:11:47 +0900 (JST)
Subject: Re: Btrfs progs pre-release 4.10-rc1
To: dsterba@suse.cz
References: <20170302145947.14775-1-dsterba@suse.com>
 <35e4a389-f8aa-6da7-b971-607744ed8c44@jp.fujitsu.com>
 <20170307115446.GR4662@suse.cz>
Cc: linux-btrfs@vger.kernel.org
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <0c346a54-9ed3-826a-8a98-adcc33df0527@jp.fujitsu.com>
Date: Wed, 8 Mar 2017 09:11:37 +0900
MIME-Version: 1.0
In-Reply-To: <20170307115446.GR4662@suse.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017/03/07 20:54, David Sterba wrote:
> On Tue, Mar 07, 2017 at 11:03:33AM +0900, Tsutomu Itoh wrote:
>> Hi David,
>>
>> On 2017/03/02 23:59, David Sterba wrote:
>>> Hi,
>>>
>>> a pre-release has been tagged. There are patches that have queued so far, but
>>> I haven't gone through everything that's in the mailinglist. The 4.10 release
>>> ETA is next week so I'll try to process the backlog and merge what would seem
>>> applicable.
>>>
>>> Changes:
>>>   * send: dump output fixes: missing newlies
>>>   * check: several fixes for the lowmem mode, improved error reporting
>>>   * build
>>>     * removed some library deps for binaries that not use them
>>>     * ctags, cscope
>>>     * split Makefile to the autotool generated part and the rest, not needed
>>>       to autogen.sh after adding a file
>>>   * shared code: sync easy parts with kernel sources
>>>   * other
>>>     * lots of cleanups
>>>     * source file reorganization: convert, mkfs, utils
>>>     * lots of spelling fixes in docs, other updates
>>>     * more tests
>>>
>>> ETA for 4.10 is in +7 days (2017-03-08).
>>>
>>> Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
>>> Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
>>>
>>> Shortlog:
>>>
>>> Austin S. Hemmelgarn (1):
>>>       btrfs-progs: better document btrfs receive security
>>>
>>> Benedikt Morbach (1):
>>>       btrfs-progs: send-dump: add missing newlines
>>>
>>> David Sterba (102):
>>
>>>       btrfs-progs: rework option parser to use getopt for global options
>>
>> I think that btrfs/{008,016,019,...} of xfstests has failed due to the
>> above patch.
>>
>> btrfs/008 1s ... [failed, exit status 1] - output mismatch (see /xfstests/results//btrfs/008.out.bad)
>>     --- tests/btrfs/008.out     2015-08-04 16:09:38.000000000 +0900
>>     +++ /xfstests/results//btrfs/008.out.bad    2017-03-07 09:00:50.581906234 +0900
>>     @@ -1,2 +1,3 @@
>>      QA output created by 008
>>     -Silence is golden
>>     +send failed
>>     +(see /xfstests/results//btrfs/008.full for details)
> 
> What's in the .full report?

$ cat 008.full
Create subvolume '/test5/send_temp_008/send'
Create a readonly snapshot of '/test5/send_temp_008/send' in '/test5/send_temp_008/send/snapshots/backup2'
Create a readonly snapshot of '/test5/send_temp_008/send' in '/test5/send_temp_008/send/snapshots/backup3'
ERROR: unable to resolve -f
send failed
$

- Tsutomu

> 
>>     ...
>>     (Run 'diff -u tests/btrfs/008.out /xfstests/results//btrfs/008.out.bad'  to see the entire diff)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

