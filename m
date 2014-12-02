Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:62225 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaLBFdj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 00:33:39 -0500
Received: by mail-vc0-f175.google.com with SMTP id hy10so5351760vcb.6
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 21:33:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
	<20141130042306.GE8916@merlins.org>
	<547C6922.6030206@gmail.com>
	<CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
	<20141201184621.5dd7fcd9@natsu>
	<CAH-HCWV7mAz0cqO9r910aNa+wzufauvc_nOOpoB9ogDPdf7RsA@mail.gmail.com>
Date: Tue, 2 Dec 2014 06:33:38 +0100
Message-ID: <CAE8gLhkiv0YnFArrzwLfnrGcqm1pRsuYBgakwrMs2W61xuothw@mail.gmail.com>
Subject: Re: Possible to undo subvol delete?
From: MegaBrutal <megabrutal@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Shriramana Sharma <samjnaa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-12-01 17:39 GMT+01:00 Shriramana Sharma <samjnaa@gmail.com>:
>
> When btrfs has so many features (esp snapshots) to prevent user
> accidentally deleting data (I liked especially
> http://www.youtube.com/v/9H7e6BcI5Fo?start=209) I think there has to
> be *some* modicum of support for warning against deleting a subvolume
> (and it seems others agree too).
>

WOW, this is pretty neat? How can I do the same actions from the
command-line? E.g. I would be curious whether a file changed since the
last snapshot. Today I have to use traditional methods like plain "ls
-l" (in case I trust the time & file size), or "diff". But in the
video we could see a directory in a view when we only seen the changed
files. How does that YaST application do so? And is there a more
enegant way to restore files to their originals than a plain "mv"?
