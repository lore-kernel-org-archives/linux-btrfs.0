Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:45308 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750786AbdHAGIH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Aug 2017 02:08:07 -0400
Date: Tue, 1 Aug 2017 11:08:05 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "marcel.cochem" <marcel.cochem@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS error: bad tree block start 0 623771648
Message-ID: <20170801110805.09226fc3@natsu>
In-Reply-To: <CAN_=hu0k8+FmrSOw5P5TAZyjzjvGyqv_ByYr27s8rZY456k87Q@mail.gmail.com>
References: <CAN_=hu0k8+FmrSOw5P5TAZyjzjvGyqv_ByYr27s8rZY456k87Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 30 Jul 2017 18:14:35 +0200
"marcel.cochem" <marcel.cochem@googlemail.com> wrote:

> I am pretty sure that not all data is lost as i can grep thorugh the
> 100 GB SSD partition. But my question is, if there is a tool to rescue
> all (intact) data and maybe have only a few corrupt files which can't
> be recovered.

There is such a tool, see https://btrfs.wiki.kernel.org/index.php/Restore

-- 
With respect,
Roman
