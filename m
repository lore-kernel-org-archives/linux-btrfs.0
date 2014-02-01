Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:41316 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaBAK3H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Feb 2014 05:29:07 -0500
Received: by mail-oa0-f42.google.com with SMTP id i7so6319875oag.15
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Feb 2014 02:29:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFDW0jJ__9EbidepKD1uF239H3ZDMvZszw_f_Nsem9iuX4Rv-w@mail.gmail.com>
References: <1389475651-19179-1-git-send-email-fdmanana@gmail.com>
	<1389493366-15264-1-git-send-email-fdmanana@gmail.com>
	<20140130031135.GA8796@birch.djwong.org>
	<CAL3q7H7fT9Mz6m=a2iqHgSyGgYO28aRt_BFc95gQYOh4gaRA2A@mail.gmail.com>
	<20140130215634.GB8796@birch.djwong.org>
	<CAFDW0jJ__9EbidepKD1uF239H3ZDMvZszw_f_Nsem9iuX4Rv-w@mail.gmail.com>
Date: Sat, 1 Feb 2014 11:29:06 +0100
Message-ID: <CAFDW0j+7roYdCaCsFoQWUdifhyLCgDL5JAbmEkDeF_Fx2+YdrA@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix btrfs boot when compiled as built-in
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Filipe David Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

okay, putting late_initcall instead of module_init fixes it for me,
but this is something you guys should decide how to handle:

//module_init(init_btrfs_fs)
late_initcall(init_btrfs_fs);

Ahmet
