From: David Sterba <dave@jikos.cz>
Subject: Re: [btrfs-progs: PATCH] scrub: fix build failure by restoring proper library ordering
Date: Mon, 7 Nov 2011 13:45:23 +0100
Message-ID: <20111107124523.GN12759@twin.jikos.cz>
References: <1320650373-15054-1-git-send-email-slyich@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	Sergei Trofimovich <slyfox@gentoo.org>
To: slyich@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1320650373-15054-1-git-send-email-slyich@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 07, 2011 at 10:19:33AM +0300, slyich@gmail.com wrote:
>  btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o
> -	$(CC) -lpthread $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
> -		$(objects) $(LDFLAGS) $(LIBS)
> +	$(CC) $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
> +		$(objects) $(LDFLAGS) $(LIBS) -lpthread

No, it's "-pthread", adds both preprocessor and linker flags.


david
