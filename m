Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:46864 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaLaGQO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Dec 2014 01:16:14 -0500
Received: by mail-pd0-f170.google.com with SMTP id v10so20479697pde.1
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Dec 2014 22:16:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54A391D8.6020201@redhat.com>
References: <20141230192910.50345rkrnf3a8akm@webmail.uniserve.com>
	<B12D4A1D-8EB5-4C9B-A8DC-7280D333E2BC@gmail.com>
	<D5E9E585-E843-4D79-A881-EB5863FB4F8B@gmail.com>
	<54A391D8.6020201@redhat.com>
Date: Wed, 31 Dec 2014 13:16:14 +0700
Message-ID: <CAG1y0seVZipbGtonxt2iFfNYO_8kzvQZgzJeYd-zJxHUCod+sQ@mail.gmail.com>
Subject: Re: should I use btrfs on Centos 7 for a new production server?
From: "Fajar A. Nugraha" <list@fajar.net>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>, Dave Stevens <geek@uniserve.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 31, 2014 at 1:04 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 12/30/14 10:06 PM, Wang Shilong wrote:
>>> I used CentOS7 btrfs myself, just doing some tests..it crashed easily.
>>> I don’t know how much efforts that Redhat do on btrfs for 7 series.
>>
>> Maybe use SUSE enterprise for btrfs will be a better choice, they offered
>> better support for btrfs as far as i know.
>
> I believe SuSE's most recent support statement on btrfs is here, I think.
>
> https://www.suse.com/releasenotes/x86_64/SUSE-SLES/12/#fate-317221

Wow. Suse use btrfs for root by default, but actively prevents user
from using compression (unless specifically overiden using module
parameter)?

Weird, since IIRC compression has been around and stable for a long time.

-- 
Fajar
