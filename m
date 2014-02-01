Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:50017 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaBATm6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Feb 2014 14:42:58 -0500
Received: by mail-ob0-f182.google.com with SMTP id wm4so6495615obc.27
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Feb 2014 11:42:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6i4uFYRjq8XWGpr1XR2K6+xqKtnbL3D3gUHiydmpCusA@mail.gmail.com>
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
Date: Sat, 1 Feb 2014 20:42:57 +0100
Message-ID: <CAFDW0jJ0AA6hef12ie4j-Dcxs8_jk2aWTYY81A=uAK1oPFv9Zg@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix btrfs boot when compiled as built-in
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: Filipe Manana <fdmanana@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> err = btrfs_hash_init();
> Did you find out what err's value was?
Its -2

Ahmet
