Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33991 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbcFVSwp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 14:52:45 -0400
Received: by mail-oi0-f43.google.com with SMTP id s66so36038649oif.1
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2016 11:52:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <29fb52eb-9aed-5d12-1631-0a8d776fb69c@gmail.com>
References: <29fb52eb-9aed-5d12-1631-0a8d776fb69c@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 22 Jun 2016 12:52:44 -0600
Message-ID: <CAJCQCtRby5U0P=m01nd_1J7ZW1tO2UVUF7caK5AK+uf1ZchaLQ@mail.gmail.com>
Subject: Re: Confusing output from fi us/df
To: Marc Grondin <marcfgrondin@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 20, 2016 at 5:30 PM, Marc Grondin <marcfgrondin@gmail.com> wrote:

> Metadata,single: Size:3.00GiB, Used:1.53GiB

Read this as:

3GiB of space on the device is reserved for metadata block group, and
1.53GiB of that is being used. The reservation means that this space
can't be used for other block group types, such as system or data. So
in some sense it is "used" but strictly speaking it's just a
reservation.




-- 
Chris Murphy
