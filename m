Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:54276 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753808AbdHUNam (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 09:30:42 -0400
Subject: Re: btrfs: Delete an unnecessary variable initialisation in
 tree_mod_log_eb_copy()
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <360126ba-e45b-0a8d-57b6-83764c4c2bce@users.sourceforge.net>
 <31e6e888-586c-3480-7d57-dbf96989a26c@users.sourceforge.net>
 <CAGqmi75EiV4nX+QCv0GR9wRbjNS5d7UernMSBdHEVsA+ubGBaQ@mail.gmail.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <b487a820-20e4-8346-9196-654682c63b4e@users.sourceforge.net>
Date: Mon, 21 Aug 2017 15:30:39 +0200
MIME-Version: 1.0
In-Reply-To: <CAGqmi75EiV4nX+QCv0GR9wRbjNS5d7UernMSBdHEVsA+ubGBaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Don't needed, and you did miss several similar places (L573 & L895) in
> that file with explicit initialisation.

Would you like to adjust any remaining places in such source files?

Regards,
Markus
