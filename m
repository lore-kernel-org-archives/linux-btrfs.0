Return-Path: <SRS0=UsBE=QC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD709C282C0
	for <linux-btrfs@archiver.kernel.org>; Sat, 26 Jan 2019 02:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8289C21855
	for <linux-btrfs@archiver.kernel.org>; Sat, 26 Jan 2019 02:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfAZCnW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 21:43:22 -0500
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:12577
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725916AbfAZCnW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 21:43:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CjAACpyEtc/1rB77ZKGhoBAQEBAQI?=
 =?us-ascii?q?BAQEBBwIBAQEBgWWCBGcFSyESJ4QBiHmMdi01AYNMlgAwCAGEOgQCAoMJIzg?=
 =?us-ascii?q?SAQMBAQEBAQECbRwMhUoBAQEBAgEjDwEUDyMFCwsOCgICJgICOR4GCgMGAgE?=
 =?us-ascii?q?Bgx4BgXkHEDSpOYEvgyuCGIRlBYELi02BQD+BESdwgU0ugxIMBIRogjUiAol?=
 =?us-ascii?q?KGoIGhgeFA4tMCYI3hHaKeR6BaoU0gzuHUI86jWshQoEUTR8ZO4JsgicXiF+?=
 =?us-ascii?q?FUy4wAQEEfQGHXQeCRgEB?=
X-IPAS-Result: =?us-ascii?q?A2CjAACpyEtc/1rB77ZKGhoBAQEBAQIBAQEBBwIBAQEBg?=
 =?us-ascii?q?WWCBGcFSyESJ4QBiHmMdi01AYNMlgAwCAGEOgQCAoMJIzgSAQMBAQEBAQECb?=
 =?us-ascii?q?RwMhUoBAQEBAgEjDwEUDyMFCwsOCgICJgICOR4GCgMGAgEBgx4BgXkHEDSpO?=
 =?us-ascii?q?YEvgyuCGIRlBYELi02BQD+BESdwgU0ugxIMBIRogjUiAolKGoIGhgeFA4tMC?=
 =?us-ascii?q?YI3hHaKeR6BaoU0gzuHUI86jWshQoEUTR8ZO4JsgicXiF+FUy4wAQEEfQGHX?=
 =?us-ascii?q?QeCRgEB?=
X-IronPort-AV: E=Sophos;i="5.56,524,1539619200"; 
   d="scan'208";a="163746291"
Received: from 182-239-193-90.ip.adam.com.au (HELO Nostromo.Underworld) ([182.239.193.90])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 26 Jan 2019 10:43:18 +0800
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
From:   Dennis Katsonis <dennisk@netspace.net.au>
Openpgp: preference=signencrypt
Message-ID: <3393e475-78fc-338e-5b11-10f80f63b6b8@netspace.net.au>
Date:   Sat, 26 Jan 2019 13:43:15 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRMTADq09y=+Bu6OvsDvyzUw6iZLRUKYhQ6di5B7zRmEQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-AU
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 1/25/19 4:22 AM, Chris Murphy wrote:
> On Thu, Jan 24, 2019 at 3:40 AM Dennis K <dennisk@netspace.net.au> wrote:
>>
>> The fact is, this thread is the first time I've seen explicitly written
>> that parents must be the same at receiving and sending ends, or else
>> btrfs-send/receive will produce a subvolume which differs from the source.
> 
> The central user error, as well as btrfs-progs bug is the failure to
> meet the requirement that the source(s) be snapshots. Either a full
> send, or an incremental send, whether with -p or -c, all of them must
> be snapshots. And none of yours were snapshots. They were read-only
> subvolumes made using 'btrfs property' to set the read-only flag, and
> those are not snapshots.

Doesn't matter even if you only send snapshots and never set a subvolume
to ro to please btrfs-send.

# btrfs sub create 1
# touch 1/file1
# btrfs sub snap -r 1 2
# btrfs send 2 | btrfs receive /destination
!# sudo btrfs prop set /destination/2/ ro false
!# rm /destination/2/file1
# touch 1/file2
# sudo btrfs sub snap -r 1 3
# btrfs send -p 2 3 | btrfs receive /storage2/
# ls /storage2/3/
file2
# ls 3/
file1 file2

The lines with the '!' are the source of the trouble, but it doesn't
have to be rm.  You could modify file 1 instead.  It is obvious that
users shouldn't do that, AFTER you've run through this sequence.

Note that snapshot 2 at the receiving end was never set back to ro.


> 
> The btrfs send command should have explicitly failed on that alone.
> 
> In my reproducer of a related user error and bug, both were snapshots,
> but they were unrelated snapshots, therefore incremental send was
> impossible, and the only explanation for such a command is the user is
> confused, made a mistake, and therefore the command should have
> failed.
> 
>>
>> A user could from the descriptions of how send/receive formats its data
>> strea, and from interpreting "clone sources" in a manner contrary to how
>> its used in the man page and the mention of incrementals, conclude that
>> send/receive is sensitive to changes at the receiving side, but its far,
>> far more likely that they will start using feature like send/receive and
>> setting snapshots to ro before they delve into how it works its magic.
> 
> Uhhh I think this is a specious statement if you think users are
> likely to delve into 'btrfs property' and somehow think setting a
> subvolume ro is making a snapshot. You're the first I've encountered
> who arrived at this logic. For now almost a decade people arrive at
> 'btrfs subvolume snapshot' as the way to make snapshots, and the -r
> flag to make them read-only snapshots.




> https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Snapshots
> 
> That page only describes snapshots in terms of the 'btrfs subvolume
> snapshot' command - the 'btrfs property' command isn't found anywhere
> on that page. So I don't actually know how you came to think setting
> the ro property on a subvolume to true, makes the subvolume a
> snapshot. I think you did it through assumption. And while there might
> be a way to fix some things to avoid such confusion in the future, I
> do think it's an edge case.
> 
> 
> The man 8 btrfs man page could amend:
> 
>        subvolume
>            Create/delete/list/manage btrfs subvolume.
> 
> to
> 
>        subvolume
>            Create/delete/list/manage btrfs subvolumes and snapshots.
> 
> it is something of btrfs geekdom that snapshots are subvolumes; but
> still not all subvolumes are snapshots. So...yeah, clarity is a good
> thing even if there some redundancy.
> 
>> Anyway, rsync sends incremental change, and its ability to replicate a
>> directory tree isn't predicated on the files present at the receiving
>> end being the same as the last time it was run...
> 
> What? Yes it is. By default it compares size and time stamp on both
> sides. If you use -c it uses checksums to compare. From the rsync man
> page:

# touch file1
# touch file2
# mkdir /destination/snap1
# rsync -r . /destination/snap1
# rm /destination/snap1/file1
# touch file3
# mkdir /destination/snap2
# cp -r /destination/snap1 /destination/snap2
# rsync -r . /destination/snap2
# ls /destination/snap2
file1 file2 file3
# ls .
file1 file2 file3

You can also add an addition "rm /destination/snap2/file1" or even "rm
-rf /destination/snap2/*" before the last rsync, and it still gives you
a full replication.

The expectation after running rsync without any explicit additional
inclusion/exclusion clauses is replication, which is what it provides.
Having deleted files at the destination end in between doesn't cause
rsync to fail meeting that expectation.



> 
>> Rsync finds files that need to be transferred using a "quick check" algorithm (by default) that looks for files that have changed in  size  or  in  last-modified
>        time.
> 
> Rsync does not keep a database on source or destination. It absolutely
> is comparing both sides, and if they aren't the same, the file is
> synced from the source to the destination.

> 
> Also, the man page for btrfs receive very clearly says the receive
> side snapshot must be present and must not have been changed since the
> last receive, or it will fail.
> 
>>       btrfs receive will fail in the following cases:
>>       1. receiving subvolume already exists
>>       2. previously received subvolume has been changed after it was received
> 
> I'm still really not following where your confusion stems from, and
> therefore I'm not sure what needs fixing other than the items I've
> already mentioned - which itself at least would have stopped you in
> your tracks, to go dig deeper or ask questions before arriving at the
> understandably confusing results you were getting.
> 

From the man page

"       btrfs receive will fail in the following cases:

        1. receiving subvolume already exists

        2. previously received subvolume has been changed after it was
received

        3. default subvolume has changed or you didn’t mount the
filesystem at the toplevel subvolume

       A subvolume is made read-only after the receiving process
finishes successfully (see BUGS below).
"

Point 2 is what you are referring to, but it doesn't fail.  It reports
success and doesn't return an error code to the shell.  So the
documentation could be improved by reflecting this fact, which can avoid
users assuming that the snapshots at the receiving end must be the same
because it didn't fail.

Also, the btrfs-send man page could be improved, by including parents as
well as clone sources as being required to be the same on both ends.

That is all.

