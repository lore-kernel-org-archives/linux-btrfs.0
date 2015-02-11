Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:62032 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbbBKMSZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 07:18:25 -0500
Message-ID: <54DB4888.7080500@users.sourceforge.net>
Date: Wed, 11 Feb 2015 13:18:16 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
MIME-Version: 1.0
To: Bas Peters <baspeters93@gmail.com>
CC: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] fs: btrfs: free-space-cache.c: remove two unnecessary
 checks before calling kfree()
References: <1423646233-16637-1-git-send-email-baspeters93@gmail.com>	<54DB3D6E.5000304@users.sourceforge.net> <CAOgR63cAKKEXJbz+OwpP-WHtuoPSg12qj72NV9WmOgA7tPQoRA@mail.gmail.com>
In-Reply-To: <CAOgR63cAKKEXJbz+OwpP-WHtuoPSg12qj72NV9WmOgA7tPQoRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> https://lkml.org/lkml/2014/10/31/606
>> http://article.gmane.org/gmane.linux.kernel/1818924
>> https://systeme.lip6.fr/pipermail/cocci/2014-October/001321.html
> 
> Oh, I see you already made the exact same change.

Would you like to add any tags to my update suggestion?

Regards,
Markus
