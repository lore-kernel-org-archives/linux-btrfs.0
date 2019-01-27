Return-Path: <SRS0=hMu+=QD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E7AC282C9
	for <linux-btrfs@archiver.kernel.org>; Sun, 27 Jan 2019 02:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB83A21920
	for <linux-btrfs@archiver.kernel.org>; Sun, 27 Jan 2019 02:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfA0B7A (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 26 Jan 2019 20:59:00 -0500
Received: from icp-osb-irony-out5.external.iinet.net.au ([203.59.1.221]:25658
        "EHLO icp-osb-irony-out5.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726262AbfA0B67 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 Jan 2019 20:58:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2C0BQD7Dk1c/1rB77ZjHAEBAQQBAQc?=
 =?us-ascii?q?EAQGBZYIEgTczJ4QBiHmNITUBg0yUGoFnOAGEOgQCAoMJIzgSAQMBAQEBAQE?=
 =?us-ascii?q?CbSiFSgEBAQECASMPARQPIxALDgoCAiYCAjkeBgoDBgIBAYMegXoHqTyBL4M?=
 =?us-ascii?q?rghiEYIELi02BQD+BESdwgU0uhGmDIYI1IgKJRQWCIIYIkFUJgjePcR6BaoU?=
 =?us-ascii?q?3gzuHUJ0pIYFWTR8ZO4JsgiQDF44yLjCBAwGJEwUCgkYBAQ?=
X-IPAS-Result: =?us-ascii?q?A2C0BQD7Dk1c/1rB77ZjHAEBAQQBAQcEAQGBZYIEgTczJ?=
 =?us-ascii?q?4QBiHmNITUBg0yUGoFnOAGEOgQCAoMJIzgSAQMBAQEBAQECbSiFSgEBAQECA?=
 =?us-ascii?q?SMPARQPIxALDgoCAiYCAjkeBgoDBgIBAYMegXoHqTyBL4MrghiEYIELi02BQ?=
 =?us-ascii?q?D+BESdwgU0uhGmDIYI1IgKJRQWCIIYIkFUJgjePcR6BaoU3gzuHUJ0pIYFWT?=
 =?us-ascii?q?R8ZO4JsgiQDF44yLjCBAwGJEwUCgkYBAQ?=
X-IronPort-AV: E=Sophos;i="5.56,528,1539619200"; 
   d="scan'208";a="198653001"
Received: from 182-239-193-90.ip.adam.com.au (HELO Nostromo.Underworld) ([182.239.193.90])
  by icp-osb-irony-out5.iinet.net.au with ESMTP; 27 Jan 2019 09:58:53 +0800
Subject: Re: Incremental receive completes succesfully despite missing files
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
 <3cfb98e1-92d4-150c-445c-9357cec9adca@netspace.net.au>
 <CAA91j0VSd=uC7ROT2+JsRszzAXWz+ti-Kf3hyw+aVS03sdn95g@mail.gmail.com>
 <8e5c7ee5-4507-66d2-6642-2e37ff11b897@mendix.com>
 <f191c52b-740f-f432-1307-dbb8f4010f66@suse.com>
 <f2d23645-ebd4-3799-bad8-2050764375bc@mendix.com>
 <d44d7535-7590-662e-ddd0-e095cb5156a4@netspace.net.au>
 <CAJCQCtRMTADq09y=+Bu6OvsDvyzUw6iZLRUKYhQ6di5B7zRmEQ@mail.gmail.com>
 <3393e475-78fc-338e-5b11-10f80f63b6b8@netspace.net.au>
 <CAJCQCtSgO4heWumhQMsp_ZRc0o79EfcvniXSoHcPyO9D=cgP2A@mail.gmail.com>
From:   Dennis Katsonis <dennisk@netspace.net.au>
Openpgp: preference=signencrypt
Message-ID: <dd80ddc0-a88b-af50-2e5b-f30602ecfabf@netspace.net.au>
Date:   Sun, 27 Jan 2019 12:58:50 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSgO4heWumhQMsp_ZRc0o79EfcvniXSoHcPyO9D=cgP2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-AU
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 1/27/19 10:09 AM, Chris Murphy wrote:
> On Fri, Jan 25, 2019 at 7:43 PM Dennis Katsonis <dennisk@netspace.net.au> wrote:
>>
>> On 1/25/19 4:22 AM, Chris Murphy wrote:
>>> On Thu, Jan 24, 2019 at 3:40 AM Dennis K <dennisk@netspace.net.au> wrote:
>>>>
>>>> The fact is, this thread is the first time I've seen explicitly written
>>>> that parents must be the same at receiving and sending ends, or else
>>>> btrfs-send/receive will produce a subvolume which differs from the source.
>>>
>>> The central user error, as well as btrfs-progs bug is the failure to
>>> meet the requirement that the source(s) be snapshots. Either a full
>>> send, or an incremental send, whether with -p or -c, all of them must
>>> be snapshots. And none of yours were snapshots. They were read-only
>>> subvolumes made using 'btrfs property' to set the read-only flag, and
>>> those are not snapshots.
>>
>> Doesn't matter even if you only send snapshots and never set a subvolume
>> to ro to please btrfs-send.
>>
>> # btrfs sub create 1
>> # touch 1/file1
>> # btrfs sub snap -r 1 2
>> # btrfs send 2 | btrfs receive /destination
>> !# sudo btrfs prop set /destination/2/ ro false
>> !# rm /destination/2/file1
>> # touch 1/file2
>> # sudo btrfs sub snap -r 1 3
>> # btrfs send -p 2 3 | btrfs receive /storage2/
>> # ls /storage2/3/
>> file2
>> # ls 3/
>> file1 file2
>>
>> The lines with the '!' are the source of the trouble, but it doesn't
>> have to be rm.  You could modify file 1 instead.  It is obvious that
>> users shouldn't do that, AFTER you've run through this sequence.
>>
>> Note that snapshot 2 at the receiving end was never set back to ro.
> 
> You're just finding more bugs (technically they are missing features,
> as checking for user error is a feature); and I'm noticing there are
> zero warnings in the man page for 'btrfs property' about unsetting ro
> on snapshots. I agree with others that as soon as the ro flag is unset
> on a snapshot, whatever metadata that makes it a snapshot and
> references its parent, including both parent UUID and received UUIDs,
> should be removed.
> 

Early on using btrfs, I assumed that the generation numbers between the
sent and received subvolume were initially the same, and that these
numbers were compared to ensure parents haven't changed relative to each
other.



>> You can also add an addition "rm /destination/snap2/file1" or even "rm
>> -rf /destination/snap2/*" before the last rsync, and it still gives you
>> a full replication.
>>
>> The expectation after running rsync without any explicit additional
>> inclusion/exclusion clauses is replication, which is what it provides.
> 
> Not exactly. From man rsync:
>>>>
>        Rsync finds files that need to be transferred using a "quick
> check" algorithm (by default) that looks for files that have changed
> in  size  or  in  last-modified
>        time.   Any changes in the other preserved attributes (as
> requested by options) are made on the destination file directly when
> the quick check indicates that the
>        file’s data does not need to be updated.
>>>>
> 
> If you initially replicate a destination using -r, the destination
> files have *current* time stamps. Each additional -r causes
> replication because the modification times for the source and
> destination are different. If you initially use 'rsync -a' and then
> follow it up with rsync -r, you'll see that the destination inodes
> remain the same, no copy happens.
> 
> Anyway, if you're saying that rsync will at *worst* do an unnecessary
> file copy, that's true and hence why -c exists; whereas with btrfs
> send receive you can apparently successfully sabotage incremental send
> receive by tampering with the receive side snapshot using 'btrfs
> property' to unset ro, and remove a file; and a send/receive will not
> make a subsequent receive side snapshot identical to the send side
> source.
> 

Yes.  The worst case is, it takes a longer and there is more disk and/or
network activity and what appears to be already sent files sent again.
But no matter what interpretation the user has, or whether this is the
result of accidental or deliberate action, or even a previously aborted
run, the end result after success is returned is a duplicated filetree,
what rsync is 'contracted' to do.

This isn't quite the case with send/receive.


> 
> 
> [chris@flap ~]$ ls -li test1/
> total 1024
> 5185860 -rw-rw-r--. 1 chris chris 524288 Jan 26 15:55 file3
> 5185861 -rw-rw-r--. 1 chris chris 524288 Jan 26 15:55 file4
> [chris@flap ~]$ ls -li test2/
> total 1024
> 5185866 -rw-rw-r--. 1 chris chris 524288 Jan 26 15:55 file3
> 5185867 -rw-rw-r--. 1 chris chris 524288 Jan 26 15:55 file4
> [chris@flap ~]$ rsync -rv test1/ test2/
> sending incremental file list
> sent 77 bytes  received 12 bytes  178.00 bytes/sec
> total size is 1,048,576  speedup is 11,781.75
> [chris@flap ~]$ ls -li test1/
> total 1024
> 5185860 -rw-rw-r--. 1 chris chris 524288 Jan 26 15:55 file3
> 5185861 -rw-rw-r--. 1 chris chris 524288 Jan 26 15:55 file4
> [chris@flap ~]$ ls -li test2/
> total 1024
> 5185866 -rw-rw-r--. 1 chris chris 524288 Jan 26 15:55 file3
> 5185867 -rw-rw-r--. 1 chris chris 524288 Jan 26 15:55 file4
> [chris@flap ~]$
> 
> 
> 
>>> I'm still really not following where your confusion stems from, and
>>> therefore I'm not sure what needs fixing other than the items I've
>>> already mentioned - which itself at least would have stopped you in
>>> your tracks, to go dig deeper or ask questions before arriving at the
>>> understandably confusing results you were getting.
>>>
>>
>> From the man page
>>
>> "       btrfs receive will fail in the following cases:
>>
>>         1. receiving subvolume already exists
>>
>>         2. previously received subvolume has been changed after it was
>> received
>>
>>         3. default subvolume has changed or you didn’t mount the
>> filesystem at the toplevel subvolume
>>
>>        A subvolume is made read-only after the receiving process
>> finishes successfully (see BUGS below).
>> "
>>
>> Point 2 is what you are referring to, but it doesn't fail.  It reports
>> success and doesn't return an error code to the shell.  So the
>> documentation could be improved by reflecting this fact, which can avoid
>> users assuming that the snapshots at the receiving end must be the same
>> because it didn't fail.
> 
> The bug is that it doesn't fail. I consider the documentation correct,
> but the command behavior is wrong.
> 
> 
>> Also, the btrfs-send man page could be improved, by including parents as
>> well as clone sources as being required to be the same on both ends.
> 
> man btrfs send does say this for clones, but not for parents. And I
> agree that the documentation needs to be more clear. Someone needs to
> volunteer to make the changes and submit a patch.
> 
>>>>
>        You must not specify clone sources unless you guarantee that
> these snapshots are exactly in the same state on both sides—both for
> the sender and the receiver.
>>>>
> 
> 

