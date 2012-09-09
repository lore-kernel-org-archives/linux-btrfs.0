Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44633 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab2IIHtP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Sep 2012 03:49:15 -0400
Received: by obbuo13 with SMTP id uo13so1474915obb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Sep 2012 00:49:14 -0700 (PDT)
Message-ID: <504C49F7.2070201@gmail.com>
Date: Sun, 09 Sep 2012 15:49:11 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: Jan Steffens <jan.steffens@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: enquiry about defrag
References: <504BDCE0.8020407@gmail.com> <CAMQ-g0d3iF-0RCGWd3RD_buXXa3j3DS2PwyUgXSAJ95=-F=c+Q@mail.gmail.com>
In-Reply-To: <CAMQ-g0d3iF-0RCGWd3RD_buXXa3j3DS2PwyUgXSAJ95=-F=c+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/09/2012 08:30 AM, Jan Steffens wrote:
> On Sun, Sep 9, 2012 at 2:03 AM, ching <lsching17@gmail.com> wrote:
>> 2. Is there any command for the fragmentation status of a file/dir ? e.g. fragment size, number of fragments.
> Use the "filefrag" command, part of e2fsprogs.
>

my image is a 16G sparse file, after defragment, it still has 101387 extents, is it normal?
