Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35430 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbcBAKXz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 05:23:55 -0500
Received: by mail-lf0-f54.google.com with SMTP id l143so25816009lfe.2
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Feb 2016 02:23:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKbQEqE0w5fewMw9YwooFXaEVT2ecfGf6ZCVvUmQg8SjGx2Zsw@mail.gmail.com>
References: <CAKbQEqE0w5fewMw9YwooFXaEVT2ecfGf6ZCVvUmQg8SjGx2Zsw@mail.gmail.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Mon, 1 Feb 2016 11:23:34 +0100
Message-ID: <CAA7pwKNH=HkfCLYtxaFSte7eg2vdwumyzddD9WPwn28i9xmuqA@mail.gmail.com>
Subject: Re: "WARNING: device 0 not present" during scrub?
To: Christian Pernegger <pernegger@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30 January 2016 at 12:59, Christian Pernegger <pernegger@gmail.com> wrote:
>
> This is on a 1-month-old Debian stable (jessie) install and yes, I
> know that means the kernel and btrfs-progs are ancient

apt-get install -t jessie-backports linux-image-4.3.0-0.bpo.1-amd64

Or something like that for the image name. Unfortunately there's no
stable backport of btrfs-tools (as they call btrfs-progs).

https://tracker.debian.org/pkg/linux
