From: Josef Bacik <josef@redhat.com>
Subject: Re: tests/misc/ls-time
Date: Mon, 18 Jan 2010 11:10:50 -0500
Message-ID: <20100118161050.GB10710@localhost.localdomain>
References: <fa9257d4-02e5-11df-9b6a-001cc0cda50c@msgid.mathom.us> <874omkzs4f.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Stone <mstone@mathom.us>,
	bug-coreutils <bug-coreutils@gnu.org>,
	linux-btrfs@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <874omkzs4f.fsf@meyering.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 17, 2010 at 04:08:16PM +0100, Jim Meyering wrote:
> Michael Stone wrote:
> > It seems that touch -a does update ctime on btrfs, invalidating one of
> > the assumptions behind this test and causing it to fail.
> 
> s/does/does not/
> 
> Thanks for the report.
> 
> I've just confirmed this test failure by building and running coreutils'
> "make check" on a btrfs file system I'd just created using mkfs.btrfs
> v0.19 on Fedora 12, btrfs-progs-0.19-9.fc12.x86_64
> 
> However, it has nothing to do with touch, but rather looks
> like a bug (or at least a difference) in btrfs.
> 
> Here's a function to provide a quick demo:
> 
> ctime_vs_link_test() { env rm -f a b x; : > a; : > b; ln a x
> stat -f --pr '%T: ' .; case "$(env ls -ct a b)" in a*b) echo pass;; \
>   *) echo fail; env stat --format='%n %z' a b;; esac; }
> 
> Use it on a few file systems.
> This test passes on all I tried except btrfs:
> [note: $HOME is ext4]
> 
>     $ for i in $HOME/tmp /t /fs/btrfs /fs/xfs /fs/nilfs2; do
>         cd $i && ctime_vs_link_test; done
>     ext2/ext3: pass
>     tmpfs: pass
>     btrfs: fail
>     a 2010-01-17 14:54:12.470194921 +0000
>     b 2010-01-17 14:54:12.471193684 +0000
>     xfs: pass
>     nilfs2: pass
> 
> In case it's not immediately obvious (time-stamp problems rarely are),
> here's a blow-by-blow:
> 
>     # After this, a's ctime precedes b's, even if just by ~1ms.
>     rm -f a b x; : > a; : > b
> 
>     # Increasing a's link count must update its ctime to the present,
>     # making it more recent than b's.
>     ln a x
> 
>     # Sorting on ctime, a should come first:
>     env ls -ct a b

Yeah its broken in F12 but it's fixed upstream.  Thanks,

Josef
