From: "Ken D'Ambrosio" <ken@jots.org>
Subject: Re: Stupid newb tricks: making a subvolume of root.
Date: Fri, 11 Nov 2011 16:47:17 -0500
Message-ID: <31df0a0994b64649a627f735105f1511@www.jots.org>
References: <6c5dc86169d45cbc1001d0daa2d51a08@www.jots.org>
        <20111110145944.GK28749@carfax.org.uk>
        <68365841c0d5cfbc86aff3e90dc407eb@www.jots.org>,
        <20111111191309.GM28749@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=fixed
Cc: <linux-btrfs@vger.kernel.org>
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111111191309.GM28749@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 11 Nov 2011 19:13:09 +0000 Hugo Mills <hugo@carfax.org.uk> wrote

>    I'd suggest reporting (on this mailing list) the panic message(s)
> you got, and how you got to them. I know there's been quite a few
> additional patches worked on since Chris pushed out the stack for
> -rc1, so it's quite plausible that your particular problem has already
> been fixed in someone's tree.

Hmmm.  I just pulled Chris's tree, and it seems to have done the trick.  It's
mounting, now.  I'm being leery of outright deleting, because grub-mkconfig
seems confused about being mounted off a different subvolume:
grub-probe: error: cannot find a device for / (is /dev/mounted?).

(Needless to say, /dev/ *is* mounted.  Likely, I've somehow confused it with
fstab or something.)

But I'm able to look at directories, cat/cp files, etc., so I now at least
*could* blow things away.  Which is handy.

Thanks!

-Ken





