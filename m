Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:33892 "EHLO
	mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbcF0Sss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 14:48:48 -0400
Received: by mail-vk0-f45.google.com with SMTP id c2so213709832vkg.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 11:48:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160627133310.GB11661@invalid>
References: <20160627132841.GA11661@invalid> <20160627133310.GB11661@invalid>
From: Henk Slager <eye1tm@gmail.com>
Date: Mon, 27 Jun 2016 20:48:46 +0200
Message-ID: <CAPmG0jbcojqdERe39Fnu20mg2e2VyxJOUi53Zy6kV_=B=q-zEA@mail.gmail.com>
Subject: Re: Bug in 'btrfs filesystem du' ?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 3:33 PM, M G Berberich <btrfs@oss.m-berberich.de> wrote:
> Am Montag, den 27. Juni schrieb M G Berberich:
>> after a balance ‘btrfs filesystem du’ probably shows false data about
>> shared data.
>
> Oh, I forgot: I have btrfs-progs v4.5.2 and kernel 4.6.2.

With  btrfs-progs v4.6.1 and kernel 4.7-rc5, the numbers are correct
about shared data.
