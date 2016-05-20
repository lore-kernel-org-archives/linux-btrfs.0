Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34526 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbcETVxI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 17:53:08 -0400
Received: by mail-oi0-f43.google.com with SMTP id b65so55388253oia.1
        for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 14:53:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS0b9Boh6VwGgXTh38f0tJqGWjTh2SMRUkYUtCwW3PSpQ@mail.gmail.com>
References: <6BBAAABC-616F-48A6-BDF2-70B23B8E0D72@me.com>
	<CAJCQCtSh-OqADqPZU1s8HjbvOBmoGB+swHNAS3FanQr5WQoyzw@mail.gmail.com>
	<1D45DF48-1D90-42AA-9F4F-70931A655F6D@me.com>
	<CAJCQCtSbLVrU-OLa8hr6P2zgwz9-8qoV3tqjC5WM0KCnneDptA@mail.gmail.com>
	<428B0808-F5BD-4B29-BF6C-C2F3188C0F9A@me.com>
	<CAJCQCtRk7scbGRqtfWMf-jyV4vq3wDEEKVi+SmtzzDKSj_+NRw@mail.gmail.com>
	<D3BB243E-5F60-4633-9966-398E0A0F5329@me.com>
	<CAJCQCtS0b9Boh6VwGgXTh38f0tJqGWjTh2SMRUkYUtCwW3PSpQ@mail.gmail.com>
Date: Fri, 20 May 2016 15:53:07 -0600
Message-ID: <CAJCQCtQrr47GtJAxgQ79ECfuU2NTnGR65HZc8QH+z6poHk62wQ@mail.gmail.com>
Subject: Re: btrfs restore fails because of NO SPACE
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Wolf Bublitz <wolf.bublitz@me.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>btrfs fi show
>Label: none  uuid: 93000933-e46d-403b-80d7-60475855e3f3
 >       Total devices 2 FS bytes used 2.56TiB
  >      devid    1 size 2.73TiB used 2.71TiB path /dev/sda
   >     devid    4 size 2.73TiB used 2.71TiB path /dev/sdb


OK so why does it only list two devices? This is a three drive or four
drive raid10? This is Btrfs raid10 specifically? I'm confused now
about the setup and why btrfs fi show isn't saying there are missing
devices, there is no such thing as two drive btrfs raid10.


Chris Murphy
