Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:36184 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750968AbdBHT1m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 14:27:42 -0500
Received: by mail-io0-f179.google.com with SMTP id j13so124277395iod.3
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Feb 2017 11:27:41 -0800 (PST)
Subject: Re: BTRFS and cyrus mail server
To: =?UTF-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <24389268.gAX5gEpECb@libor-nb>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e6da1740-cdb0-96ce-4f44-3b8fa32fd052@gmail.com>
Date: Wed, 8 Feb 2017 14:21:13 -0500
MIME-Version: 1.0
In-Reply-To: <24389268.gAX5gEpECb@libor-nb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-08 13:38, Libor Klepáč wrote:
> Hello,
> inspired by recent discussion on BTRFS vs. databases i wanted to ask on
> suitability of BTRFS for hosting a Cyrus imap server spool. I haven't found
> any recent article on this topic.
>
> I'm preparing migration of our mailserver to Debian Stretch, ie. kernel 4.9
> for now. We are using XFS for storage now. I will migrate using imapsync to
> new server. Both are virtual machines running on vmware on Dell hardware.
> Disks are on battery backed hw raid controllers over vmfs.
>
> I'm considering using BTRFS, but I'm little concerned because of reading this
> mailing list ;)
FWIW, as long as you're using a recent kernel and take the time to do 
proper maintenance on the filesystem, BTRFS is generally very stable. 
WRT mail servers specifically, before we went to a cloud service for 
e-mail where I work, we used Postfix + Dovecot on our internal server, 
and actually saw a measurable performance improvement when switching 
from XFS to BTRFS.  That was about 3.12-3.18 vintage on the kernel 
though, so YMMV.
>
> I'm interested in using:
>  - compression (emails should compress well - right?)
Yes, very well assuming you're storing the actual text form of them (I 
don't recall if Cyrus does so, but I know Postfix, Sendmail, and most 
other FOSS mail server software do).  The in-line compression will also 
help reduce fragmentation, and unless you have a really fast storage 
device, should probably improve performance in general.
>  - maybe deduplication (cyrus does it by hardlinking of same content messages
> now) later
Deduplication beyond what Cyrus does is probably not worth it.  In most 
cases about 10% of an e-mail in text form is going to be duplicated if 
it's not a copy of an existing message, and that 10% is generally spread 
throughout the file (stuff like MIME headers and such), so you would 
probably see near zero space savings for doing anything beyond what 
Cyrus does while using an insanely larger amount of resources.
>  - snapshots for history
Make sure you use a sane exponential thinning system.  Once you get past 
about 300 snapshots, you'll start seeing some serious performance 
issues, and even double digits might hurt performance at the scale 
you're talking about.
>  - send/receive for offisite backup
This is up to you, but I would probably not use send-receive for 
off-site backups.  Unless you're using reflinking, you can copy all the 
same attributes that send-receive does using almost any other backup 
tool, and other tools often have much better security built-in.  Send 
streams also don't compress very well in my experience, so using 
send-receive has a tendency to require more network resources.
>  - what about data inlining, should it be turned off?
Generally no, and especially if you handle lots of small e-mails. 
Metadata blocks need to be looked up to open and read files anyway, 
in-lining the data means that you don't need to read in any more blocks 
for files small enough to fit in the spare space in the metadata block 
or when you only need to read the first few kilobytes of the file (and 
if Cyrus' IMAP/POP server works anything like most others I've seen, it 
will be parsing those first few KB because that's where the headers it 
indexes are).
>
> Our Cyrus pool consist of ~520GB of data in ~2,5million files, ~2000
> mailboxes.
> We have message size limit of ~25MB, so emails are not bigger than that.
> There are however bigger files, these are per mailbox caches/index files of
> cyrus (some of them are around 300MB) - and these are also files which are
> most modified.
I would mark these files NOCOW for performance reasons (and because if 
they're just caches and indexes, they should be pretty simple to 
regenerate).
> Rest of files (messages) are usualy just writen once.
>
> -----------
> I started using btrfs on backup server as a storage for 4 backuppc run in
> containers (backups are then send away with btrbk), year ago.
> After switching off data inlining i'm satisfied, everything works (send/
> receive is sometime slow, but i guess it's because of sata disks on receive
> side).

