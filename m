Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:34126 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbcFXRkS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 13:40:18 -0400
Received: by mail-io0-f182.google.com with SMTP id g13so98101655ioj.1
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 10:40:17 -0700 (PDT)
Subject: Re: Trying to rescue my data :(
To: Steven Haigh <netwiz@crc.id.au>, linux-btrfs@vger.kernel.org
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au>
 <CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>
 <dd7fd123-c3a2-7ad0-bf22-a67a1b1a97d7@crc.id.au>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d00790ae-bf8d-ee18-06a9-d0c5f6010129@gmail.com>
Date: Fri, 24 Jun 2016 13:40:09 -0400
MIME-Version: 1.0
In-Reply-To: <dd7fd123-c3a2-7ad0-bf22-a67a1b1a97d7@crc.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-24 13:05, Steven Haigh wrote:
> On 25/06/16 02:59, ronnie sahlberg wrote:
> What I have in mind here is that a file seems to get CREATED when I copy
> the file that crashes the system in the target directory. I'm thinking
> if I 'cp -an source/ target/' that it will make this somewhat easier (it
> won't overwrite the zero byte file).
You may want to try with rsync (rsync -vahogSHAXOP should get just about 
everything possible out of the filesystem except for some security 
attributes (stuff like SELinux context), and will give you nice 
information about progress as well).  It will keep running in the face 
of individual read errors, and will only try each file once.  It also 
has the advantage of showing you the transfer rate and exactly where in 
the directory structure you are, and handles partial copies sanely too 
(it's more reliable restarting an rsync transfer than a cp one that got 
interrupted part way through).

