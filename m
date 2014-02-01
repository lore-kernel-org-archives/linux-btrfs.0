Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:65028 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbaBAV2l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Feb 2014 16:28:41 -0500
Received: by mail-bk0-f49.google.com with SMTP id v15so2459396bkz.8
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Feb 2014 13:28:39 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAFDW0jJ0AA6hef12ie4j-Dcxs8_jk2aWTYY81A=uAK1oPFv9Zg@mail.gmail.com>
References: <1389475651-19179-1-git-send-email-fdmanana@gmail.com>
	<1389493366-15264-1-git-send-email-fdmanana@gmail.com>
	<20140130031135.GA8796@birch.djwong.org>
	<CAL3q7H7fT9Mz6m=a2iqHgSyGgYO28aRt_BFc95gQYOh4gaRA2A@mail.gmail.com>
	<20140130215634.GB8796@birch.djwong.org>
	<CAFDW0jJ__9EbidepKD1uF239H3ZDMvZszw_f_Nsem9iuX4Rv-w@mail.gmail.com>
	<CAFDW0j+7roYdCaCsFoQWUdifhyLCgDL5JAbmEkDeF_Fx2+YdrA@mail.gmail.com>
	<CAL3q7H4cUj3p+mNBciMjoT0QSXfCWmc61QLWKgLNZSKRx0+JbQ@mail.gmail.com>
	<CAFDW0j+MkhJUxR+zePXkewKpbK5qUGxiG-B6mgzPEJNVEEBgxw@mail.gmail.com>
	<CAL3q7H6i4uFYRjq8XWGpr1XR2K6+xqKtnbL3D3gUHiydmpCusA@mail.gmail.com>
	<CAFDW0jJ0AA6hef12ie4j-Dcxs8_jk2aWTYY81A=uAK1oPFv9Zg@mail.gmail.com>
Date: Sat, 1 Feb 2014 21:28:39 +0000
Message-ID: <CAL3q7H79upha4-DPuXV2BeKmD2-yBizia_=g=FVTz4zkv-od+Q@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix btrfs boot when compiled as built-in
From: Filipe David Manana <fdmanana@gmail.com>
To: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 1, 2014 at 7:42 PM, Ahmet Inan
<ainan@mathematik.uni-freiburg.de> wrote:
>>> err = btrfs_hash_init();
>> Did you find out what err's value was?
> Its -2

Thanks, that was very helpful Ahmet.

>
> Ahmet



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
