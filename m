Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37FD1C282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 10:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1140120861
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 10:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbfAWKoe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:44:34 -0500
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:45446
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727148AbfAWKod (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 05:44:33 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CcAQD4REhc/1rB77ZjGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBZYIEa0ohEhgPhAGIeYxxLTUBg0yUFYFnOAGEOgQCAiOCUiM?=
 =?us-ascii?q?4EgEDAQEBAQEBAm0ohUIJAQUjDwEjIxALGAICERUCAjkeEwYCAQFXgkcBggC?=
 =?us-ascii?q?sFoEvhUOEb4ELi02BQD+BESeCPS6EPIEEgkoUgiEiAqImCYIzj2cegWaGGoJ?=
 =?us-ascii?q?PhmVjnQkhgVZNHxmBWQqBRIInF44yLjCBAwGHUgeCRgE?=
X-IPAS-Result: =?us-ascii?q?A2CcAQD4REhc/1rB77ZjGgEBAQEBAgEBAQEHAgEBAQGBZ?=
 =?us-ascii?q?YIEa0ohEhgPhAGIeYxxLTUBg0yUFYFnOAGEOgQCAiOCUiM4EgEDAQEBAQEBA?=
 =?us-ascii?q?m0ohUIJAQUjDwEjIxALGAICERUCAjkeEwYCAQFXgkcBggCsFoEvhUOEb4ELi?=
 =?us-ascii?q?02BQD+BESeCPS6EPIEEgkoUgiEiAqImCYIzj2cegWaGGoJPhmVjnQkhgVZNH?=
 =?us-ascii?q?xmBWQqBRIInF44yLjCBAwGHUgeCRgE?=
X-IronPort-AV: E=Sophos;i="5.56,510,1539619200"; 
   d="scan'208";a="163099138"
Received: from 182-239-193-90.ip.adam.com.au (HELO Nostromo.Underworld) ([182.239.193.90])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 23 Jan 2019 18:44:26 +0800
Subject: Re: Incremental receive completes succesfully despite missing files
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
From:   Dennis Katsonis <dennisk@netspace.net.au>
Openpgp: preference=signencrypt
Message-ID: <3cfb98e1-92d4-150c-445c-9357cec9adca@netspace.net.au>
Date:   Wed, 23 Jan 2019 21:44:24 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-AU
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 1/22/19 9:23 AM, Chris Murphy wrote:
> On Sun, Jan 20, 2019 at 3:34 AM Dennis K <dennisk@netspace.net.au> wrote:
>>
>> Apologies in advance, if the issue I put forward is actually the
>> intended behavior of BTRFS.
>>
>> I have noted while playing with sub-volumes, and trying to determine
>> what exactly are the requirements for a subvolume to act as a legitimate
>> parent during a receive operation, that modification of one subvolume,
>> can affect children subvolumes that are received.
>>
>> It's possible I have noted this before when directories which I though
>> should have existed in the destination volume, where not present,
>> despite being present in the snapshot at the sending end.  (ie, a
>> subvolume is sent incrementally, but the received subvolume is missing
>> files that exist on the sent side).
>>
>> I can replicate this as follows
>>
>> Create the subvolumes and put some files in them.
>> # btrfs sub create 1
>> # btrfs sub create 2
>> # cd 1
>> # dd if=/dev/urandom bs=1M count=10 of=test
>> # cd ..
>> # btrfs sub snap 1 2
>> # dd if=/dev/urandom bs=1M count=1 of=test2
>> # cd ..
>>
>> Now set as read-only to send.  Subvolume 1 has the file "test, and
>> subvolume 2 has the files "test" and "test2".
>> # btrfs prop set 1 ro true
>> # btrfs prop set 2 ro true
>>
>> Send, snapshot 2 is an incremental send.  The files created are the
>> expected sizes.
>> # btrfs send 1 -f /tmp/1
>> # btrfs send -p 1 2 -f /tmp 2
>>
>> Now we make subvolume one read-write
>> # btrfs prop set 1 ro false
>> # rm 1/test
>>
>> Delete subvolume 2 and then recreate it be receiving it.
>> # btrfs sub del 2
>> # btrfs receive -f /tmp/2 .
> 
> This is an unworkable workflow, for multiple reasons. Your 1 and 2
> subvolumes are not related to each other, and incremental send should
> fail. So I think you might have stumbled on a bug.
> 
> (from man page)
>        btrfs send [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>]
> <subvol> [<subvol>...]
> 
> (simplifed)
> 
>        btrfs send [-p <parent>] [<subvol>...
> 
> 
> If <parent> has a UUID of 54321, I expect that <subvol> must have
> Parent UUID of 54321, or the send command should fail.
> 
> Setting aside the possibility for a bug, let's describe the proper
> workflow. Your subvolumes 1 and 2 are separate file trees, they're not
> related and shouldn't ever appear together in a send/receive. If you
> want to do incremental send, to send only changes that happen in 1 and
> 2 the workflow looks like this.
> 
> btrfs sub snap -r 1 1.20190120
> btrfs sub snap -r 2 2.20190120
> btrfs send 1.20190120 | btrfs receive /destination/
> btrfs send 2.20190120 | btrfs recieve /destination/
> 
> First the snapshots are from the outset read only. And these are the
> snapshots that you will send to the destination file systems, without
> p, to initially populate the destination. Second, you will make
> changes to original subvolumes 1 and 2, which are still rw subvolumes.
> And then and some later time you snapshot them again, thus:
> 
> btrfs sub snap -r 1 1.20190121
> btrfs sub snap -r 2 2.20190121
> 
> And then send the difference or increment with the command:
> 
> btrfs send -p 1.20190120 1.20190121 | btrfs receive /destination/
> btrfs send -p 2.20190120 2.20190121 | btrfs receive /destination/
> 
> And if the original volume dies and you need to restore these
> subvolumes to their most recent state:
> 
> btrfs send 1.20190121 | btrfs receive /newdestination/
> btrfs send 2.20190121 | btrfs receive /newdestination/
> btrfs sub snap 1.20190121 1
> btrfs sub snap 2.20190121 2
> 
> You do not need to do incremental restore, because the subvolume that
> appears as a result of an incremental send is *fully* populated, not
> merely with just the incremental data. And in this case I take a
> default rw snapshot.
> 
> I literally never use the 'property set' feature to set ro and unset
> ro because I think it's dangerous.

I think my previous e-mail did not go through.  Basically, if it is
assumed that a btrfs-receive operation will result in a subvolume which
matches the source file for file, then this assumption or expectation
won't be met if one deletes files from the subvolume at the receiving
end which is going to be referred to as the parent.

This can happen inadvertently, or even through filesystem corruption
(which I experienced).


> 
> 
>>
>> I understand that during send/receive, a snapshot is taken of the parent
>> subvolume, then it is modified.  The problem is that if that snapshot is
>> modified, then these modifications will affect the received subvolumes,
>> including, in this case, silent data loss.
> 
> 
> I think this is user error. And the bug is actually a feature request
> for better error handling to account for the user inadvertently trying
> to do an incremental send with a subvolume that does not have a
> matching parent UUID to the -p specified parent subvolume's UUID. I
> thought there was a check for this but I'm virtually certain I've run
> into this problem myself with no warning and yes it's an unworkable
> result at destination.
> 

I do note that btrfs-send man page states "You must not specify clone
sources unless you guarantee that these snapshots are exactly in the
same state on both sides—both for the sender and the receiver.".
Perhaps this could be changed to state "clone or parent", as it could be
interpreted as not being applicable if you specify a parent only.
