Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61265 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2IIJLn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Sep 2012 05:11:43 -0400
Received: by obbuo13 with SMTP id uo13so1521458obb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Sep 2012 02:11:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <504C49F7.2070201@gmail.com>
References: <504BDCE0.8020407@gmail.com>
	<CAMQ-g0d3iF-0RCGWd3RD_buXXa3j3DS2PwyUgXSAJ95=-F=c+Q@mail.gmail.com>
	<504C49F7.2070201@gmail.com>
Date: Sun, 9 Sep 2012 16:11:42 +0700
Message-ID: <CAG1y0sdFTKLX8N1VnSYzxZ-Xr4kDPtYGG6ixMrPwBWQPRVAGgg@mail.gmail.com>
Subject: Re: enquiry about defrag
From: "Fajar A. Nugraha" <list@fajar.net>
To: ching <lsching17@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 9, 2012 at 2:49 PM, ching <lsching17@gmail.com> wrote:
> On 09/09/2012 08:30 AM, Jan Steffens wrote:
>> On Sun, Sep 9, 2012 at 2:03 AM, ching <lsching17@gmail.com> wrote:
>>> 2. Is there any command for the fragmentation status of a file/dir ? e.g. fragment size, number of fragments.
>> Use the "filefrag" command, part of e2fsprogs.
>>
>
> my image is a 16G sparse file, after defragment, it still has 101387 extents, is it normal?

Is compression enabled? If so, yes, it's normal.

-- 
Fajar
