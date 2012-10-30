Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48643 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934731Ab2J3Vk2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 17:40:28 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so457535pad.19
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2012 14:40:28 -0700 (PDT)
Message-ID: <50904949.8010603@gmail.com>
Date: Wed, 31 Oct 2012 05:40:25 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: Felix Pepinghege <postfach@pepinghege.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Why btrfs inline small file by default?
References: <508FB45B.9040101@gmail.com> <508FC26A.1010206@pepinghege.net> <CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com>
In-Reply-To: <CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/30/2012 08:17 PM, cwillu wrote:
>>> If there is a lot of small files, then the size of metadata will be
>>> undesirable due to deduplication
>>
>> Yes, that is a fact, but if that really matters depends on the use-case
>> (e.g., the small files to large files ratio, ...). But as btrfs is designed
>> explicitly as a general purpose file system, you usually want the good
>> performance instead of the better disk-usage (especially as disk space isn't
>> expensive anymore).
> As I understand it, in basically all cases the total storage used by
> inlining will be _smaller_, as the allocation doesn't need to be
> aligned to the sector size.
>

if i have 10G small files in total, then it will consume 20G by default.

ching
