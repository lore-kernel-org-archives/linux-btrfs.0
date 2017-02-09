Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34453 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752484AbdBINAi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Feb 2017 08:00:38 -0500
Received: by mail-io0-f193.google.com with SMTP id c80so1966114iod.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Feb 2017 05:00:37 -0800 (PST)
Subject: Re: BTRFS and cyrus mail server
To: Adam Borowski <kilobyte@angband.pl>
References: <24389268.gAX5gEpECb@libor-nb>
 <e6da1740-cdb0-96ce-4f44-3b8fa32fd052@gmail.com>
 <20170209114904.dbr6irzbfxkr35xj@angband.pl>
Cc: =?UTF-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <eccb1284-6779-da31-7ee7-4ad2fe586c5e@gmail.com>
Date: Thu, 9 Feb 2017 07:53:13 -0500
MIME-Version: 1.0
In-Reply-To: <20170209114904.dbr6irzbfxkr35xj@angband.pl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-09 06:49, Adam Borowski wrote:
> On Wed, Feb 08, 2017 at 02:21:13PM -0500, Austin S. Hemmelgarn wrote:
>>>  - maybe deduplication (cyrus does it by hardlinking of same content messages
>>> now) later
>> Deduplication beyond what Cyrus does is probably not worth it.  In most
>> cases about 10% of an e-mail in text form is going to be duplicated if it's
>> not a copy of an existing message, and that 10% is generally spread
>> throughout the file (stuff like MIME headers and such), so you would
>> probably see near zero space savings for doing anything beyond what Cyrus
>> does while using an insanely larger amount of resources.
>
> The problem is: users in a company tend to send mails to a group, so a bunch
> of people have plenty of identical mails... then every delivered mail has
> slightly different headers prepended, usually of different length to make
> sure that 20MB mail has its contents shifted by a single byte so you can't
> dedupe blocks after the first.
Unless it's multiple copies of the mail or multiple BCC's, the headers 
will (with limited exception) be identical because they contain all the 
same TO: and CC: lines.
>
>>>  - snapshots for history
>> Make sure you use a sane exponential thinning system.  Once you get past
>> about 300 snapshots, you'll start seeing some serious performance issues,
>> and even double digits might hurt performance at the scale you're talking
>> about.
>
> It's not anywhere that bad in my experience.  As far as I know, regular
> POSIX operations are not affected by the number of reflinks, only stuff like
> balance (greatly), dedupe, and, to a lesser extent, deletion of snapshots.
> You don't want to hit 100k snapshots like I once did, but even then the
> filesystem keeps working in regular operation.
However, proper maintenance on a BTRFS filesystem is not just POSIX 
operations.  IOW, if you want a manageable filesystem that doesn't take 
forever to fix when something goes wrong, you want to avoid large 
numbers of snapshots.
>
> (Those snapshots were not deduped beyond natural reflinking from
> snapshotting, every one having no more than a few hundreds links.  I now
> realize that it'd probably explode had I tried coalescing identical
> files between then.)
>
>>>  - send/receive for offisite backup
>> This is up to you, but I would probably not use send-receive for off-site
>> backups.  Unless you're using reflinking, you can copy all the same
>> attributes that send-receive does using almost any other backup tool, and
>> other tools often have much better security built-in.  Send streams also
>> don't compress very well in my experience, so using send-receive has a
>> tendency to require more network resources.
>
> I'd heartily recommend using _both_.  You use send-receive for that 3-hour
> (or 1-hour!) backup, and rsync for dailies.  You do value your mails enough
> to back them to two places, right?  Then you get to enjoy efficiency of
> send-receive (statting everything takes ages!), while rsync helps with
> paranoia about send-receive cloning potential filesystem errors.
>
>>> Our Cyrus pool consist of ~520GB of data in ~2,5million files, ~2000
>>> mailboxes.
>>> We have message size limit of ~25MB, so emails are not bigger than that.
>>> There are however bigger files, these are per mailbox caches/index files of
>>> cyrus (some of them are around 300MB) - and these are also files which are
>>> most modified.
>> I would mark these files NOCOW for performance reasons (and because if
>> they're just caches and indexes, they should be pretty simple to
>> regenerate).
>
> Using NOCOW with snapshots gets you the worst of both worlds: all the
> downsides of CoW with no btrfs goodies.  NOCOW is useful only for "I wish I
> had partitioned a traditional filesystem for this file, and I don't need to
> snapshot it".
However, if those really are just caches and/or indexes, then you 
shouldn't need to snapshot them because the software can just rebuild 
them if they get lost, and that's actually safer in many cases than 
restoring backup copies.

