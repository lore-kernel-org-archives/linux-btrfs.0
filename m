Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58402 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2IIAaX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Sep 2012 20:30:23 -0400
Received: by ieje11 with SMTP id e11so1035516iej.19
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Sep 2012 17:30:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <504BDCE0.8020407@gmail.com>
References: <504BDCE0.8020407@gmail.com>
Date: Sun, 9 Sep 2012 02:30:23 +0200
Message-ID: <CAMQ-g0d3iF-0RCGWd3RD_buXXa3j3DS2PwyUgXSAJ95=-F=c+Q@mail.gmail.com>
Subject: Re: enquiry about defrag
From: Jan Steffens <jan.steffens@gmail.com>
To: ching <lsching17@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 9, 2012 at 2:03 AM, ching <lsching17@gmail.com> wrote:
> 2. Is there any command for the fragmentation status of a file/dir ? e.g. fragment size, number of fragments.

Use the "filefrag" command, part of e2fsprogs.
