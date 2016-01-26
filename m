Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:33799 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934058AbcAZMX6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 07:23:58 -0500
Received: by mail-lf0-f50.google.com with SMTP id 17so103666478lfz.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jan 2016 04:23:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAcrkYKpSsC+H0BCM9pk=-S6VBF_qPKXMFswoGsVSUzRdTrKBg@mail.gmail.com>
References: <CAAcrkYJRzvmwdVVYLJ_+LAob=tGQrW3=R7hDfbU_jE3kaD+Kxw@mail.gmail.com>
 <CAA7pwKNoYVUYT6QzGQxiz6jW9zEPvp6DjRxBPun6Z+SpDcuUjg@mail.gmail.com>
 <CAAcrkY+3w--OGYWwben+KYohdqwBBryDn8REJ6tiBk4jM3Tp9w@mail.gmail.com>
 <CAA7pwKP6KXHHkp4pALjbxqOFT2ve5T8r0RNcbmdVWXqLmveDgg@mail.gmail.com>
 <CAAcrkYJKoooUWOOsbqXot=U4voe+V_8iMf1NODbjUqMdn6g0Hg@mail.gmail.com>
 <CAPmG0jahDyaHhh1dZxS_L=0C27R_4GWtZeaGTrL50Gze4BRtKg@mail.gmail.com> <CAAcrkYKpSsC+H0BCM9pk=-S6VBF_qPKXMFswoGsVSUzRdTrKBg@mail.gmail.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Tue, 26 Jan 2016 13:23:36 +0100
Message-ID: <CAA7pwKM+OZoF7v3Xq=J=KSpidsGsY4hi6TxxkSAKZAJRODCDSg@mail.gmail.com>
Subject: Re: uknown issues - different sha256 hash - files corruption
To: John Smith <lenovomi@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 26 January 2016 at 12:54, John Smith <lenovomi@gmail.com> wrote:
>
> is it possible there is connection with
> https://bugzilla.kernel.org/show_bug.cgi?id=93581, i have 2x 3tb wd
> red drives, kernel 4.4.

No, WD Red aren't Shingled Magnetic Recording (SMR) drives.
