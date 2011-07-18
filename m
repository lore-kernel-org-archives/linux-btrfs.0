From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH 0/6] Series short description
Date: Tue, 19 Jul 2011 00:38:50 +0200
Message-ID: <4E24B5FA.4040704@libero.it>
References: <20110718173151.4029.66663.stgit@venice.bhome>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110718173151.4029.66663.stgit@venice.bhome>
List-ID: <linux-btrfs.vger.kernel.org>

Sorry,

discard this email

On 07/18/2011 07:33 PM, Goffredo Baroncelli wrote:
> The following series implements...
> 
> ---
> 
> Goffredo Baroncelli (6):
>       Add info for the commands.
>       Add the header/footer/introduction of the man page.
>       helpextract: tool to extract the info for the help from the source.
>       Update the makefile for generating the man page.
>       Show the help messages from the info in the comment.
>       Update the makefile for generating the help messages.
> 
> 
>  Makefile           |   28 +++
>  btrfs.c            |  210 +++++++++++++++++++++++++
>  btrfs_cmds.c       |  276 +++++++++++++++++++++++++++++++++
>  helpextract.c      |  435 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  man/btrfs.8.in     |  359 -------------------------------------------
>  man/btrfs.8.in.old |  359 +++++++++++++++++++++++++++++++++++++++++++
>  scrub.c            |   79 +++++++++
>  7 files changed, 1380 insertions(+), 366 deletions(-)
>  create mode 100644 helpextract.c
>  delete mode 100644 man/btrfs.8.in
>  create mode 100644 man/btrfs.8.in.old
> 

