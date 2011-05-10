From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: "btrfs filesystem label" command
Date: Tue, 10 May 2011 20:18:04 +0200
Message-ID: <4DC9815C.4010504@inwind.it>
References: <20913344.376.1304976991802.JavaMail.root@mail.placs.net>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: BJ Quinn <bj@placs.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20913344.376.1304976991802.JavaMail.root@mail.placs.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I suppose that you are familiar with 'git' and the standard unix command
(like cd, make...). The quick way is the following:

$ cd /tmp
$ git clone -b label \
	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
$ cd btrfs-progs-unstable.git
$ make
$ ./btrfs


Hoping that this may help you

Regards
G.Baroncelli

On 05/09/2011 11:36 PM, BJ Quinn wrote:
> Hi, 
> 
> Sorry to ask what's probably a painfully obvious question, but I'd like to use your btrfs filesystem label command. For the life of me, I can't quite figure out what the process would be to download the btrfs-progs sources and apply your patch and use the command. Can you point me in the right direction? 
> 
> Thanks! 
> 
> -BJ Quinn 
> 

