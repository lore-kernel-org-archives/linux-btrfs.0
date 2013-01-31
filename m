Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40305 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab3AaW7S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 17:59:18 -0500
Received: by mail-bk0-f46.google.com with SMTP id j5so1614875bkw.33
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 14:59:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130131220040.GP16285@carfax.org.uk>
References: <CAFKW2=ETvfXTyth9jHoc=6yZQDLj+5c8kRTZd4+79zVbs4LU-w@mail.gmail.com>
 <20130131220040.GP16285@carfax.org.uk>
From: Christopher Thorjussen <joffer@onlinebackupcompany.com>
Date: Thu, 31 Jan 2013 23:59:01 +0100
Message-ID: <CAFKW2=G3D+KCtamjvVAm8XdWQLhQASKYiLZ2y9f81EJ94Xj-mA@mail.gmail.com>
Subject: Re: btrfs subvolume list - with three subvolumes, the second is
 missing/not showing
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 31, 2013 at 11:00 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Thu, Jan 31, 2013 at 04:39:52PM +0100, Christopher Thorjussen wrote:
>> I've created a large btrfs volume out of two large raid-60 devices. On
>> there I've created three subvolumes. When I do a list of those the 2nd
>> isn't displayed. If I however add a fouth subvol they all gets listed.
>
>    This is (probably) a known bug in the userspace tools. It should be
> fixed in David Sterba's integration branch:
>
>   git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130130
>    Hugo.
>

Thanks. Will have a look.
For now I just created a "hidden" subvolume with .HiddenName as name.
That gives me four subvol and all are listed.

/Christopher
