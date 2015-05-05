Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:36758 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbbEEG4j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 02:56:39 -0400
Received: by obbkp3 with SMTP id kp3so70630767obb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2015 23:56:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA=o1pmDtxRCgWZjUwazq8G+ch__oMAdXLUhnu3-N7ieASZO_Q@mail.gmail.com>
References: <CAA=o1pmDtxRCgWZjUwazq8G+ch__oMAdXLUhnu3-N7ieASZO_Q@mail.gmail.com>
Date: Tue, 5 May 2015 00:56:38 -0600
Message-ID: <CAJCQCtRUQw9910kyX6kMaR+iA=QR1UA95nJ4Njc5uLZaZr62bA@mail.gmail.com>
Subject: Re: fstab: use UUID or labe?
From: Chris Murphy <lists@colorremedies.com>
To: Rory Jaffe <rsjaffe@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 4, 2015 at 7:42 PM, Rory Jaffe <rsjaffe@gmail.com> wrote:

> If the original drive fails, will that UUID still point to the
> filesystem, or is it better to use the label for the filesystem? Will
> the filesystem mount in either case with the failure of the original
> drive?

A Btrfs volume has one label and one UUID. All member drives contain
this information. So the answer is, it doesn't matter whether you use
label or UUID in fstab, except that with UUID there's a lower chance
of collision.

-- 
Chris Murphy
