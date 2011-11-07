From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: space cache generation (...) does not match inode (...)
Date: Mon, 7 Nov 2011 10:37:54 +0100
Message-ID: <201111071037.54434.Martin@lichtvoll.de>
References: <CAObL_7Hc0AGOB8Jk-o_hseiqxEfDWFLSnMkhLLiu00GVbr729Q@mail.gmail.com> <4E3FD332.5020002@redhat.com> (sfid-20110808_160940_762241_B4222AF9)
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Josef Bacik <josef@redhat.com>, Andrew Lutomirski <luto@mit.edu>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E3FD332.5020002@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

Am Montag, 8. August 2011 schrieb Josef Bacik:
> On 08/06/2011 10:16 PM, Andrew Lutomirski wrote:
> > I've always gotten space cache generation warnings, but some time
> > after 3.0 they started going nuts.  I get:
> > 
> > space cache generation (14667727114112179905) does not match inode
> > (154185)
> > 
> > and other similar messages (with a huge number and a smaller number)
> > at rates higher than one message per ms.  They don't happen
> > constantly, but they come in bursts big enough to fill my log buffer.
> 
> Yeah sorry that's going to happen when you first switch to 3.0.  We
> switched the space cache stuff over to using the normal checksumming
> code so all old space cache is going to look invalid.  This is nothing
> to worry about, it will just end up discarded and re-generated. 

I found these too and found this thread about it.

Now I restarted 3.1 another time but I still get these. Less than before, 
but they still appear. Is that okay?

I thought BTRFS would update the space cache once and then be done with 
it. When exactly should BTRFS be done with it?

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
