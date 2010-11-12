From: Marek Otahal <markotahal@gmail.com>
Subject: Re: Btrfs-progs: Update man page for mixed data+metadata option.
Date: Fri, 12 Nov 2010 22:28:35 +0800
Message-ID: <201011122228.37322.markotahal@gmail.com>
References: <1289412138-8049-1-git-send-email-mitch.harder@sabayonlinux.org> <20101112074105.GD10179@dhcp231-156.rdu.redhat.com> <AANLkTikvR_1Jpz6unuuGDWSB0eUoNMFMeL-zUQyw1FOz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikvR_1Jpz6unuuGDWSB0eUoNMFMeL-zUQyw1FOz@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 12 of November 2010 18:44:12 you wrote:
> On Thu, Nov 11, 2010 at 11:41 PM, Josef Bacik <josef@redhat.com> wrote:
> > On Fri, Nov 12, 2010 at 05:47:14PM +1100, Chris Samuel wrote:
> >> On 11/11/10 23:52, Josef Bacik wrote:
> >> > This feature incurs a performance penalty in larger filesystems, it is
> >> > recommended for use with filesystems of 1 GiB or smaller.
> >> 
> >> Maybe slightly stronger, for example:
> >> 
> >> This feature incurs a performance penalty for larger filesystems and it
> >> is ONLY recommended for use with filesystems of 1 GiB or smaller.
> >> 
> >> Is it worth having a check and a warning printed if a user does
> >> try and make a filesystem larger than 1GiB with this option ?
> >> 
> >> Just in case they don't RTFM...
> > 
> > No because depending on your usage it's actually kind of usefull for
> > anything less than 5 GiB, and you're only looking at about a 5-10% perf
> > degredation when using it on larger filesystems.  Thanks,
> 
> Then a warning of 10% slowdown if > 10GB would be good.  It's
> surprising how many will just read some forum post and not concern
> themselves with the docs at all.
> 
> And making them type "yes" if > 100GB is probably a good idea too...
My 2c: I'm against bloating the program just because of people who don't RTFM. 
Just mention it clearly in docs and that's enough, linux does what it's asked 
for, not the "Are you really really sure you want to do this?" known from some 
other OS. Anyway, btrfs-progs would be probably run by a user with root 
privileges and such should be aware of what actions they do, or read the man 
page. My opinion. 
Cheers, Mark

-- 

Marek Otahal :o)
