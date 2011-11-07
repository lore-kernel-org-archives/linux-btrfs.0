From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [btrfs-progs: PATCH] scrub: fix build failure by restoring proper
 library ordering
Date: Mon, 07 Nov 2011 14:25:25 +0100
Message-ID: <4EB7DC45.6070407@jan-o-sch.net>
References: <1320650373-15054-1-git-send-email-slyich@gmail.com> <20111107124523.GN12759@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: slyich@gmail.com, chris.mason@oracle.com,
	Sergei Trofimovich <slyfox@gentoo.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111107124523.GN12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On 07.11.2011 13:45, David Sterba wrote:
> On Mon, Nov 07, 2011 at 10:19:33AM +0300, slyich@gmail.com wrote:
>>  btrfs: $(objects) btrfs.o btrfs_cmds.o scrub.o
>> -	$(CC) -lpthread $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
>> -		$(objects) $(LDFLAGS) $(LIBS)
>> +	$(CC) $(CFLAGS) -o btrfs btrfs.o btrfs_cmds.o scrub.o \
>> +		$(objects) $(LDFLAGS) $(LIBS) -lpthread
> 
> No, it's "-pthread", adds both preprocessor and linker flags.

It seems to do the right thing on x86_64, although...

If I'm reading my gcc manpage right, it is telling me to use -pthread
only for ia64 on HPUX, powerpc and sparc. (gcc 4.4.5 that is)

-Jan
