From: Alex Dedul <rotmer@gmail.com>
Subject: Re: [PATCH 2/2] Btrfs: Fix setting umask when POSIX ACLs are not
	enabled
Date: Thu, 17 Sep 2009 09:49:58 +0300
Message-ID: <5f8586d40909162349n6286c50bsb88c070141e65c77@mail.gmail.com>
References: <m3r5u6jfec.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3r5u6jfec.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris!

On Thu, Sep 17, 2009 at 8:42 AM, Chris Ball <cjb@laptop.org> wrote:
> We currently set sb->s_flags |= MS_POSIXACL unconditionally, which is
> incorrect -- it tells the VFS that it shouldn't set umask because we
> will, yet we don't set it ourselves if we aren't using POSIX ACLs, so
> the umask ends up ignored.
>
> Signed-off-by: Chris Ball <cjb@laptop.org>
> ---
>  fs/btrfs/super.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Works fine now! Thank you .. :)

With best regards from the Soul, Alex.
