Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37653 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbHEHGl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 03:06:41 -0400
Received: by wibhh20 with SMTP id hh20so10161308wib.0
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Aug 2015 00:06:40 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 5 Aug 2015 09:06:40 +0200
Message-ID: <CAK4jXzy8OpRMnF=hYEamZVxiumH9Xn_8uDo_xOQhYfLf3cA9dA@mail.gmail.com>
Subject: Why subvolume and not just volume?
From: Martin <sha256sum@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Does anyone know the reason subvolumes are not called just volumes? I
mean, the top subvolume is not called a volume, so there is nothing to
be "sub" of.

Also, what is the penalty of a subvolume compared to a directory? From
a design perspective, couldn't all directories just be subvolumes?

Martin
