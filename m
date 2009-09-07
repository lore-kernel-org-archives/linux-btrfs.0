From: David Zeuthen <zeuthen@gmail.com>
Subject: Re: Discrepant st_rdev and st_dev stats in btrfs block and fs device
	ids
Date: Sun, 6 Sep 2009 21:43:31 -0400
Message-ID: <7b13a0f80909061843w70f74ea7ibfca3c8761f679ba@mail.gmail.com>
References: <7a83c8e0909060851w70305142oc775b28bcd1ef093@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Marcus <smurca@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7a83c8e0909060851w70305142oc775b28bcd1ef093@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

> Can anyone repeat this? Any ideas why this could be happening?
> Is this expected?

There was some discussion about this some time ago, see

 http://news.gmane.org/find-root.php?message_id=%3c7b13a0f80904120735r41736455hb7e226ab8ad30bd7%40mail.gmail.com%3e

I don't think it's resolved yet - the work-around I currently use in
devkit-disks-daemon (which is used by e.g. GNOME to show names
and icons for storage devices) looks like this:

 http://cgit.freedesktop.org/DeviceKit/DeviceKit-disks/tree/src/devkit-disks-mount-monitor.c?id=006#n351

and I don't think this will work for multi-disk btrfs filesystems. Thinking
about this again, we probably want to treat such btrfs multi-disk filesystems
in the UI the same way we treat e.g. md raid devices....

    David
