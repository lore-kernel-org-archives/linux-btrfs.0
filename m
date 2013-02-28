Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:47650 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3B1Oox convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 09:44:53 -0500
Received: by mail-ie0-f173.google.com with SMTP id 9so2145730iec.4
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2013 06:44:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512F6B30.1060409@petaramesh.org>
References: <512F6B30.1060409@petaramesh.org>
Date: Thu, 28 Feb 2013 08:44:52 -0600
Message-ID: <CAE5mzviUkAqHW_Hz9RTVYaJfX=tMZy7_a69xNxUkX2emo-8hww@mail.gmail.com>
Subject: Re: Does defragmenting even work
From: cwillu <cwillu@cwillu.com>
To: =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Cc: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 28, 2013 at 8:35 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
> BTW...
>
> I'm not even sure that "btrfs filesystem defrag <somefile>" actually
> does anything...
>
> If I run "filefrag <somefile>" afterwards, it typically shows the same
> number of fragments that it did prior to running defrag...
>
> I'm not sure about how it actually works and what I should expect...

Can't explain something if I can't see the data I'm explaining :p
