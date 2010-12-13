Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:60830 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab0LMS5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Dec 2010 13:57:21 -0500
MIME-Version: 1.0
In-Reply-To: <20101213020657.GB4513@thunk.org>
References: <20101210023852.GB3059@thunk.org> <AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V@mail.gmail.com>
 <AANLkTikeiv2jQM5hhghs1Zd2d=5CbRLKMgYvqHqpm76m@mail.gmail.com>
 <AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
 <AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
 <20101212023415.GG3059@thunk.org> <AANLkTim=i8wDnML+K4uGK_neNDCiWxtKGDx01O+3joaE@mail.gmail.com>
 <AANLkTinhHTqqpP=pQ8Foyc9xeaZi65GHGHGY51OyZtvF@mail.gmail.com>
 <20101212124354.GA4513@thunk.org> <AANLkTikZkCs7Wee2=uhe3bw96Pggcv0jsCkZ+nkWEQ+=@mail.gmail.com>
 <20101213020657.GB4513@thunk.org>
From: Jon Nelson <jnelson@jamponi.net>
Date: Mon, 13 Dec 2010 12:56:59 -0600
Message-ID: <AANLkTinMWS-yyzWJ3oBo_KS9jXt4p4pveo+SPTLiWnCt@mail.gmail.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
To: "Ted Ts'o" <tytso@mit.edu>, Jon Nelson <jnelson@jamponi.net>,
        Matt <jackdachef@gmail.com>, Chris Mason <chris.mason@oracle.com>,
        Andi Kleen <andi@firstfloor.org>, Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <mbroz@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 12, 2010 at 8:06 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Dec 12, 2010 at 07:11:28AM -0600, Jon Nelson wrote:
>> I'm glad you've been able to reproduce the problem! If you should need
>> any further assistance, please do not hesitate to ask.
>
> This patch seems to fix the problem for me.  (Unless the partition is
> mounted with mblk_io_submit.)
>
> Could you confirm that it fixes it for you as well?

I believe I have applied the (relevant) inode.c changes to
bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc, rebuilt and begun testing.
Now at 28 passes without error, I think I can say that the patch
appears to resolve the issue.

-- 
Jon
