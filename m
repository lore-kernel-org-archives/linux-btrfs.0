Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:48107 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932513AbdHVOYw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 10:24:52 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id 171CD5335
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 16:24:51 +0200 (MEST)
Date: Tue, 22 Aug 2017 16:24:51 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: netapp-alike snapshots?
Message-ID: <20170822142451.GI14804@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
 <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 2017-08-22 (15:44), Peter Becker wrote:
> Is use: https://github.com/jf647/btrfs-snap
> 
> 2017-08-22 15:22 GMT+02:00 Ulli Horlacher <framstag@rus.uni-stuttgart.de>:
> > With Netapp/waffle you have automatic hourly/daily/weekly snapshots.
> > You can find these snapshots in every local directory (readonly).
> > Example:
> >
> > framstag@fex:/sw/share: ll .snapshot/
> > drwxr-xr-x  framstag root - 2017-08-14 10:21:47 .snapshot/daily.2017-08-15_0010
> > drwxr-xr-x  framstag root - 2017-08-14 10:21:47 .snapshot/daily.2017-08-16_0010
> > drwxr-xr-x  framstag root - 2017-08-14 10:21:47 .snapshot/daily.2017-08-17_0010
> > drwxr-xr-x  framstag root - 2017-08-14 10:21:47 .snapshot/daily.2017-08-18_0010
> > drwxr-xr-x  framstag root - 2017-08-18 23:59:29 .snapshot/daily.2017-08-19_0010
> > drwxr-xr-x  framstag root - 2017-08-19 21:01:25 .snapshot/daily.2017-08-20_0010
> > drwxr-xr-x  framstag root - 2017-08-20 19:48:40 .snapshot/daily.2017-08-21_0010
> > drwxr-xr-x  framstag root - 2017-08-20 02:50:18 .snapshot/hourly.2017-08-20_1210
> > drwxr-xr-x  framstag root - 2017-08-20 02:50:18 .snapshot/hourly.2017-08-20_1610
> > drwxr-xr-x  framstag root - 2017-08-20 19:48:40 .snapshot/hourly.2017-08-20_2010
> > drwxr-xr-x  framstag root - 2017-08-21 00:42:28 .snapshot/hourly.2017-08-21_0810
> > drwxr-xr-x  framstag root - 2017-08-21 00:42:28 .snapshot/hourly.2017-08-21_1210
> > drwxr-xr-x  framstag root - 2017-08-21 13:05:28 .snapshot/hourly.2017-08-21_1610

btrfs-snap does not create local .snapshot/ sub-directories, but saves the
snapshots in the toplevel root volume directory.



-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
