Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:36616 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbcFDG1U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jun 2016 02:27:20 -0400
Received: by mail-lf0-f53.google.com with SMTP id b73so66500356lfb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 23:27:19 -0700 (PDT)
Subject: Re: "No space left on device" and balance doesn't work
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAE8gLhm0-+kkwFv1-+t+tWLrZrzh4B9cJUDRrgPpwfvB_obVCA@mail.gmail.com>
 <bcf8033b-bafe-f927-efdb-b898d2b00a24@gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <575274C1.8070801@gmail.com>
Date: Sat, 4 Jun 2016 09:27:13 +0300
MIME-Version: 1.0
In-Reply-To: <bcf8033b-bafe-f927-efdb-b898d2b00a24@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

02.06.2016 15:56, Austin S. Hemmelgarn пишет:
> 
> In your particular situation, what's happened is that you have all the
> space allocated to chunks, but have free space within those chunks.
> Balance never puts data in existing chunks, and you can't allocate any
> new chunks, so you can't run a balance.  However, because of that free
> space in the chunks, you can still use the filesystem itself for
> 'regular' filesystem operations.
> 

How balance decides where to put data from chunks it frees? I.e. let's
say I have one free data chunk and 10 chunks filled to 10%. Will "btrfs
ba start -dusage=10" pack data from all 10 chunks into single one, this
freeing 10 chunks for further processing?
