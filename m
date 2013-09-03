Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760506Ab3ICUxX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 16:53:23 -0400
Message-ID: <52264C3A.5010202@redhat.com>
Date: Tue, 03 Sep 2013 15:53:14 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Kusanagi Kouichi <slash@ac.auone-net.jp>
Subject: Re: [PATCH 2/3] Btrfs-progs: move test tools to tests/ subdir
References: <1370992519-21369-1-git-send-email-sandeen@redhat.com> <1370992519-21369-3-git-send-email-sandeen@redhat.com> <20130902144345.GZ23113@twin.jikos.cz>
In-Reply-To: <20130902144345.GZ23113@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/2/13 9:43 AM, David Sterba wrote:
> On Tue, Jun 11, 2013 at 06:15:18PM -0500, Eric Sandeen wrote:
>> Move test tools to tests/
> 
>>  rename btrfs-corrupt-block.c => tests/btrfs-corrupt-block.c (100%)
> 
> IMO this is not a test by itself, so it should stay in the toplevel dir.

Hum, well, it has a main() - ok, not a test, but a tool used for testing?
Ok, fine.  Maybe misc/ someday ;)

> 
>> --- /dev/null
>> +++ b/tests/Makefile
>> @@ -0,0 +1,49 @@
> eg.
> TOPLEVEL = ..
> 
>> +CFLAGS += -I..
> CFLAGS += -I$(TOPLEVEL)
> 
>> +
>> +objects := $(addprefix ../, $(objects))
> 
> etc. s/../$(TOPLEVEL)

Ok, that's probably good.

>> +
>> +lib_LIBS = -lblkid -luuid
>> +LIBS = $(lib_LIBS) $(addprefix ../, $(libs_static))
>> +
>> +# These last 2 don't actually build anymore
>> +progs = btrfs-corrupt-block ioctl-test quick-test send-test # random-test dir-test
>> +
>> +libs_static = libbtrfs.a
>> +libs = $(addprefix ../, $(libs_static))
>> +headers = $(libbtrfs_headers)
>> +
> 
> the default rule belongs here, ie
> all: $(progs)
> 
> Otherwise 'make' in the tests/ subdir will try to execute the first .c
> file it needs to build.
> 
>> +.c.o:
>> +	$(Q)$(check) $<
>> +	@echo "    [CC]     $@"
>> +	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
> 
> Until now we've had only man/ and it does not compile anything, now
> tests/ duplicate the .c.o: rule. The rules are not exported to subdirs,
> we need either to duplicate it in every subdir/Makefile or have
> something like Makefile.rules or builddefs, and each Makefile has to
> keep track back to the toplevel dir. We want to be able to 'make tests'
> but also just 'make' in the tests/ directory -- which does not work
> right now.

*nod* ok.  It's been a while since I did make hacking, sorry.

>> +
>> +all: $(progs)
>> +
> 
>> +clean :
>> +	$(Q)rm -f *.o .*.d $(progs)
>> +
>> +-include .*.d
> 
> This should probably look like the update in the toplevel makefile:
> 
> ifneq ($(MAKECMDGOALS),clean)
> -include $(objects:.o=.o.d) $(cmd-objects:.o=.o.d) $(subst .btrfs,, $(filter-out btrfsck.o.d, $(progs:=.o.d)))
> endif
> 
> and for the clean: rule a minor update: the .d files do not start with '.'.
> (Both introduced in "btrfs-progs: Fix automatic prerequisite generation")
> 
> Let's start with moving just the tests, see how the makefiles work and
> then proceed with cmds/ and the shared kernel files.

Sounds like a plan.

thanks for the review,
-Eric

> 
> david
> 

