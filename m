From: David Nicol <davidnicol@gmail.com>
Subject: Re: how to know when all space from a snapshot delete is freed?
Date: Wed, 2 Mar 2011 15:38:40 -0600
Message-ID: <AANLkTi=AW27zWD_Oc-eGh5GH3d5d7ngQCx5fUAtP=w7_@mail.gmail.com>
References: <iklfnu$efc$1@dough.gmane.org> <4D6EB349.1050507@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Goffredo Baroncelli <kreijack@libero.it>,
	"Brian J. Murrell" <brian@interlinx.bc.ca>,
	linux-btrfs@vger.kernel.org
To: kreijack@inwind.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D6EB349.1050507@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

the patch has been working in production at the sponsor's site for
some weeks. It has not been merged, or even built by anyone else, to
my knowledge.

The working kernel patch is at https://patchwork.kernel.org/patch/482721/

The open question, that everyone has more important things to do than
talk about, is, to flesh out the iputs stuff or discard it or put it
in as-is.  That question is orthogonal to the function of the
notification-of-completed-dead-root-removal parts, which are complete
and work as designed.

On Wed, Mar 2, 2011 at 3:14 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> David worked for some time to a solution to this kind of problem. But I
> don't know if it was merged.
>
> See posts on this ML with subject "PATCH: IOCTL#21 progs"


-- 
"Reasonable, civil, and intelligent people have not left much of a
mark on history." -- T. Herman Zweibel
