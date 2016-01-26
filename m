Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:33177 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966210AbcAZOcv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 09:32:51 -0500
Received: by mail-ig0-f177.google.com with SMTP id z14so57932918igp.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jan 2016 06:32:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA7pwKM+OZoF7v3Xq=J=KSpidsGsY4hi6TxxkSAKZAJRODCDSg@mail.gmail.com>
References: <CAAcrkYJRzvmwdVVYLJ_+LAob=tGQrW3=R7hDfbU_jE3kaD+Kxw@mail.gmail.com>
 <CAA7pwKNoYVUYT6QzGQxiz6jW9zEPvp6DjRxBPun6Z+SpDcuUjg@mail.gmail.com>
 <CAAcrkY+3w--OGYWwben+KYohdqwBBryDn8REJ6tiBk4jM3Tp9w@mail.gmail.com>
 <CAA7pwKP6KXHHkp4pALjbxqOFT2ve5T8r0RNcbmdVWXqLmveDgg@mail.gmail.com>
 <CAAcrkYJKoooUWOOsbqXot=U4voe+V_8iMf1NODbjUqMdn6g0Hg@mail.gmail.com>
 <CAPmG0jahDyaHhh1dZxS_L=0C27R_4GWtZeaGTrL50Gze4BRtKg@mail.gmail.com>
 <CAAcrkYKpSsC+H0BCM9pk=-S6VBF_qPKXMFswoGsVSUzRdTrKBg@mail.gmail.com> <CAA7pwKM+OZoF7v3Xq=J=KSpidsGsY4hi6TxxkSAKZAJRODCDSg@mail.gmail.com>
From: John Smith <lenovomi@gmail.com>
Date: Tue, 26 Jan 2016 15:32:21 +0100
Message-ID: <CAAcrkYJZnrFZKaEQQi6p48KHcGhkQh0LB_eC7xGAcNgFeLfTHA@mail.gmail.com>
Subject: Re: uknown issues - different sha256 hash - files corruption
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok,

i finished with testing and corruption (different hashes) happens only
from lvm -> to btrfs, lvm -> lvm.

Also i count sha256 on the same file on lvm 3x and i got 3 different hashes.

Is it still hw issue or bug in LVM/ext4?




On Tue, Jan 26, 2016 at 1:23 PM, Patrik Lundquist
<patrik.lundquist@gmail.com> wrote:
> On 26 January 2016 at 12:54, John Smith <lenovomi@gmail.com> wrote:
>>
>> is it possible there is connection with
>> https://bugzilla.kernel.org/show_bug.cgi?id=93581, i have 2x 3tb wd
>> red drives, kernel 4.4.
>
> No, WD Red aren't Shingled Magnetic Recording (SMR) drives.
