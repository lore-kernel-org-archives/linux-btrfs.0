Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:54079 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbbBKMT6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 07:19:58 -0500
MIME-Version: 1.0
In-Reply-To: <54DB4888.7080500@users.sourceforge.net>
References: <1423646233-16637-1-git-send-email-baspeters93@gmail.com>
	<54DB3D6E.5000304@users.sourceforge.net>
	<CAOgR63cAKKEXJbz+OwpP-WHtuoPSg12qj72NV9WmOgA7tPQoRA@mail.gmail.com>
	<54DB4888.7080500@users.sourceforge.net>
Date: Wed, 11 Feb 2015 13:19:57 +0100
Message-ID: <CAOgR63f5CFES_PYGwF-0M3-c_nNDQiNwQMPSfeHhea9e3oebCA@mail.gmail.com>
Subject: Re: [PATCH] fs: btrfs: free-space-cache.c: remove two unnecessary
 checks before calling kfree()
From: Bas Peters <baspeters93@gmail.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Markus,

2015-02-11 13:18 GMT+01:00 SF Markus Elfring <elfring@users.sourceforge.net>:
>>> https://lkml.org/lkml/2014/10/31/606
>>> http://article.gmane.org/gmane.linux.kernel/1818924
>>> https://systeme.lip6.fr/pipermail/cocci/2014-October/001321.html
>>
>> Oh, I see you already made the exact same change.
>
> Would you like to add any tags to my update suggestion?

No, it's fine, I should've checked before submitting the patch.

>
> Regards,
> Markus
