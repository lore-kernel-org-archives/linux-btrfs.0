Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:52857 "EHLO
        smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751626AbdKNHOz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 02:14:55 -0500
Received: from smtp18.relay.ord1c.emailsrvr.com (localhost [127.0.0.1])
        by smtp18.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 613C5E02D2
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 02:14:55 -0500 (EST)
Received: from smtp73.ord1d.emailsrvr.com (relay.ord1c.rsapps.net [172.28.255.120])
        by smtp18.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTPS id 5C9BFE0152
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 02:14:55 -0500 (EST)
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
To: Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
 <20171101101510.218eeead@natsu>
 <CAH=dxU56geiO7MuWSbPgpfBQ3vbkPYm6juQZzu3-1=-RzG+ZSQ@mail.gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <ebfc86ae-8398-4ecf-d3c9-a0f3e997e9d9@rqc.ru>
Date: Tue, 14 Nov 2017 10:14:55 +0300
MIME-Version: 1.0
In-Reply-To: <CAH=dxU56geiO7MuWSbPgpfBQ3vbkPYm6juQZzu3-1=-RzG+ZSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14/11/17 06:39, Dave wrote:
> My rsync command currently looks like this:
>
> rsync -axAHv --inplace --delete-delay --exclude-from="/some/file"
> "$source_snapshop/" "$backup_location"
As I learned from Kai Krakow in this maillist, you should also add 
--no-whole-file if both sides are local. Otherwise target space usage 
can be much worse (but fragmentation much better).

I wonder what is your justification for --delete-delay, I just use --delete.

Here's what I use: --verbose --archive --hard-links --acls --xattrs 
--numeric-ids --inplace --delete --delete-excluded --stats. Since in my 
case source is always remote, there's no --no-whole-file, but there's 
--numeric-ids.

> In particular, I want to know if I should or should not be using these options:
>
>          -H, --hard-links            preserve hard links
>          -A, --acls                  preserve ACLs (implies -p)
>          -X, --xattrs                preserve extended attributes
>          -x, --one-file-system       don't cross filesystem boundaries
I don't know any semantic use of hard links in modern systems. There're 
ACLs on some files in /var/log/journal on systems with systemd. Synology 
actively uses ACL, but it's implementation is sadly incompatible with 
rsync. There can always be some ACLs or xattrs set by sysadmin manually. 
End result, I always specify first three options where possible just in 
case (even though man page says that --hard-links may affect performance).

> I had to use the "x" option to prevent rsync from deleting files in
> snapshots in the backup location (as the source location does not
> retain any snapshots). Is there a better way?
Don't keep snapshots under rsync target, place them under ../snapshots 
(if snapper supports this):

> # find . -maxdepth 2
> .
> ./snapshots
> ./snapshots/2017-11-08T13:18:20+00:00
> ./snapshots/2017-11-08T15:10:03+00:00
> ./snapshots/2017-11-08T23:28:44+00:00
> ./snapshots/2017-11-09T23:41:30+00:00
> ./snapshots/2017-11-10T22:44:36+00:00
> ./snapshots/2017-11-11T21:48:19+00:00
> ./snapshots/2017-11-12T21:27:41+00:00
> ./snapshots/2017-11-13T23:29:49+00:00
> ./rsync
Or, specify them in --exclude and avoid using --delete-excluded. Or keep 
using -x if it works, why not?

--

With Best Regards,
Marat Khalili
