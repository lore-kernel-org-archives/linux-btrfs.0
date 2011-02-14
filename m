From: Marti Raudsepp <marti@juffo.org>
Subject: Re: btrfs: compression breaks cp and cross-FS mv, FS_IOC_FIEMAP bug?
Date: Mon, 14 Feb 2011 19:58:17 +0200
Message-ID: <AANLkTi=N8DiusfP6Rey=Cx4qjUSbiLS3jnbjASGQ=Lcx@mail.gmail.com>
References: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com>
 <20110213155730.GK19533@dhcp231-156.rdu.redhat.com> <AANLkTi=Rj_3MmLawJj-K8u+pGbT_NZzqzVGFOsvOK8eC@mail.gmail.com>
 <20110213161329.GL19533@dhcp231-156.rdu.redhat.com> <1297695521-sup-9460@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	btrfs hackers <linux-btrfs@vger.kernel.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1297695521-sup-9460@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 14, 2011 at 17:01, Chris Mason <chris.mason@oracle.com> wrote:
> Or, it could just be delalloc ;)

I suspect delalloc. After creating the file, filefrag reports "1
extent found", but for some reason it doesn't actually print out
details of the extent.

After a "sync" call, the extent appears and "cp" starts working as expected:

% rm -f foo bar
% echo foo > foo
% sync
% filefrag -v foo
Filesystem type is: 9123683e
File size of foo is 4 (1 block, blocksize 4096)
 ext logical physical expected length flags
   0       0        0            4096 not_aligned,inline,eof
foo: 1 extent found
% cp foo bar
% hexdump bar
0000000 6f66 0a6f
0000004

Without sync:

% rm -f foo bar
% echo foo > foo
% filefrag -v foo
Filesystem type is: 9123683e
File size of foo is 4 (1 block, blocksize 4096)
 ext logical physical expected length flags
foo: 1 extent found
% cp foo bar
% hexdump bar
0000000 0000 0000
0000004

Regards,
Marti
