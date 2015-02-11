Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:39582 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbbBKLt1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 06:49:27 -0500
MIME-Version: 1.0
In-Reply-To: <54DB3D6E.5000304@users.sourceforge.net>
References: <1423646233-16637-1-git-send-email-baspeters93@gmail.com>
	<54DB3D6E.5000304@users.sourceforge.net>
Date: Wed, 11 Feb 2015 12:49:26 +0100
Message-ID: <CAOgR63cAKKEXJbz+OwpP-WHtuoPSg12qj72NV9WmOgA7tPQoRA@mail.gmail.com>
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

2015-02-11 12:30 GMT+01:00 SF Markus Elfring <elfring@users.sourceforge.net>:
>> kfree checks whether the pointer it is passed is NULL. The two foregoing
>> checks are therefore unnecessary.
>>
>> This issue was detected using Coccinelle.
>
> Would you like to integrate my update suggestion "btrfs: Deletion of
> unnecessary checks before six function calls"?
> https://lkml.org/lkml/2014/10/31/606
> http://article.gmane.org/gmane.linux.kernel/1818924
> https://systeme.lip6.fr/pipermail/cocci/2014-October/001321.html

Oh, I see you already made the exact same change.
I'll just drop my patch in that case.

>
> Regards,
> Markus
>
