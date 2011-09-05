From: Leen Besselink <leen@consolejunkie.net>
Subject: Re: df output wrong ?
Date: Mon, 05 Sep 2011 12:58:22 +0200
Message-ID: <4E64AB4E.60609@consolejunkie.net>
References: <4E649B73.6060802@consolejunkie.net> <20110905101918.GK9907@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110905101918.GK9907@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/05/2011 12:19 PM, Hugo Mills wrote:
>
>    Snapshot/subvolume deletion is asynchronous -- it can take a while
> to happen. Try waiting a minute or two after the snapshot deletion and
> before looking at df -h.
>
>    Hugo.
>

As I didn't see any disc activity, I thought it was done.

I just tried it again, it does seem to work the way you mentioned.

Thanks.

Just a quick question: would 'btrfs filesystem sync /path' help speed
that up ?

Like for example if a sys-admin sees that he's running out of space and
needs
to remove some old snapshots immediately.

Or when an automated backup first removes old snapshots to create room
for a new backup just before starting that backup.


