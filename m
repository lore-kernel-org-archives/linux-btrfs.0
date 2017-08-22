Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:44466 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751061AbdHVQpd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 12:45:33 -0400
Date: Tue, 22 Aug 2017 21:45:31 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: netapp-alike snapshots?
Message-ID: <20170822214531.44538589@natsu>
In-Reply-To: <20170822142451.GI14804@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
        <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
        <20170822142451.GI14804@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 22 Aug 2017 16:24:51 +0200
Ulli Horlacher <framstag@rus.uni-stuttgart.de> wrote:

> On Tue 2017-08-22 (15:44), Peter Becker wrote:
> > Is use: https://github.com/jf647/btrfs-snap
> > 
> > 2017-08-22 15:22 GMT+02:00 Ulli Horlacher <framstag@rus.uni-stuttgart.de>:
> > > With Netapp/waffle you have automatic hourly/daily/weekly snapshots.
> > > You can find these snapshots in every local directory (readonly).
> > > Example:
> > >
> > > framstag@fex:/sw/share: ll .snapshot/
> > > drwxr-xr-x  framstag root - 2017-08-14 10:21:47 .snapshot/daily.2017-08-15_0010
> > > drwxr-xr-x  framstag root - 2017-08-14 10:21:47 .snapshot/daily.2017-08-16_0010
> > > drwxr-xr-x  framstag root - 2017-08-14 10:21:47 .snapshot/daily.2017-08-17_0010
> > > drwxr-xr-x  framstag root - 2017-08-14 10:21:47 .snapshot/daily.2017-08-18_0010
> > > drwxr-xr-x  framstag root - 2017-08-18 23:59:29 .snapshot/daily.2017-08-19_0010
> > > drwxr-xr-x  framstag root - 2017-08-19 21:01:25 .snapshot/daily.2017-08-20_0010
> > > drwxr-xr-x  framstag root - 2017-08-20 19:48:40 .snapshot/daily.2017-08-21_0010
> > > drwxr-xr-x  framstag root - 2017-08-20 02:50:18 .snapshot/hourly.2017-08-20_1210
> > > drwxr-xr-x  framstag root - 2017-08-20 02:50:18 .snapshot/hourly.2017-08-20_1610
> > > drwxr-xr-x  framstag root - 2017-08-20 19:48:40 .snapshot/hourly.2017-08-20_2010
> > > drwxr-xr-x  framstag root - 2017-08-21 00:42:28 .snapshot/hourly.2017-08-21_0810
> > > drwxr-xr-x  framstag root - 2017-08-21 00:42:28 .snapshot/hourly.2017-08-21_1210
> > > drwxr-xr-x  framstag root - 2017-08-21 13:05:28 .snapshot/hourly.2017-08-21_1610
> 
> btrfs-snap does not create local .snapshot/ sub-directories, but saves the
> snapshots in the toplevel root volume directory.

It is beneficial to not have snapshots in-place. With a local directory of
snapshots, issuing things like "find", "grep -r" or even "du" will take an
inordinate amount of time and will produce a result you do not expect.

For some of those tools the problem can be avoided (by always keeping in mind
to use "-x" with du, or "--one-file-system" with tar), but not for all of them.

Personally I prefer to have a /snapshots directory on every FS, and e.g. timed
snapshots of /home/username/src will live in /snapshots/home-username-src/. No
point to hide it there with a dot either, as it's convenient to be able to
browse older snapshots with GUI filemanagers (which hide dot-files by default).

-- 
With respect,
Roman
