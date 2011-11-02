From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [RFC] [PROGS] Regression tests
Date: Wed, 02 Nov 2011 20:31 +0100
Message-ID: <41272591.1IrILq7W5C@venice>
References: <b17197c7428fa5b75a2d9ac95806fdd41be60424.1320010556.git.hugo@carfax.org.uk>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <b17197c7428fa5b75a2d9ac95806fdd41be60424.1320010556.git.hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hi hugo

On Sunday, 30 October, 2011 21:44:56 Hugo Mills wrote:
> Add a shell-script based test harness for performing regression tests
> on btrfs tools. This is not intended as a test system for kernel
> issues, but instead to put the userspace tools through their paces.
> 
> Currently implemented tests are compilation of all tools, and checking
> argument counting on "btrfs sub snap". Other tests will follow.


> 
> Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
> ---
> 
>    If nobody has any major comments or objections, I'll feed this up
> to Chris from the integration branch when I next send him a stack of
> patches.
> 
>    Hugo.
> 
> 
>  Makefile          |    8 +++
>  test/001u.sh      |   23 ++++++++++
>  test/002s.sh      |   42 +++++++++++++++++
>  test/functions.sh |  128
> +++++++++++++++++++++++++++++++++++++++++++++++++++++ test/run-tests    |  
> 13 +++++
>  5 files changed, 214 insertions(+), 0 deletions(-)
>  create mode 100755 test/001u.sh
>  create mode 100755 test/002s.sh
>  create mode 100644 test/functions.sh
>  create mode 100755 test/run-tests
> 
> diff --git a/Makefile b/Makefile
> index edee1a0..24e1ce1 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -100,4 +100,12 @@ install: $(progs) install-man
>  	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
>  	if [ -e btrfs-convert ]; then $(INSTALL) btrfs-convert
> $(DESTDIR)$(bindir); fi
> 
> +test: test-userspace test-root
> +
> +test-userspace:
> +	./test/run-tests
> +
> +test-root:
> +	sudo ./test/run-tests
> +
>  -include .*.d
> diff --git a/test/001u.sh b/test/001u.sh
> new file mode 100755
> index 0000000..d2cadff
> --- /dev/null
> +++ b/test/001u.sh
> @@ -0,0 +1,23 @@
> +#!/bin/bash
> +
> +. test/functions.sh
> +
> +unset BTRFS_TESTS_VOLUMES
> +
> +announce compilation
> +
> +export CC=gcc-4.6
                ^^^^^^
What does mean ? If the user has a different compiler, the test will fail ?

[....]

> diff --git a/test/run-tests b/test/run-tests
> new file mode 100755
> index 0000000..981fc22
> --- /dev/null
> +++ b/test/run-tests
> @@ -0,0 +1,13 @@
> +#!/bin/bash
> +
> +testdir=$(dirname $0)
> +
> +if [ $UID -eq 0 ]; then
> +	type=s
> +else
> +	type=u
> +fi
> +
> +for test in ${testdir}/[0-9][0-9][0-9]${type}.sh; do

it is possible to replace 

	${testdir}/[0-9][0-9][0-9]${type}.sh

with (note the '*')

	${testdir}/[0-9][0-9][0-9]${type}*.sh

so we could create test with a more verbose name, and we could avoid test name 
collision. 


Then we can group the number in range like:
000-100    -> tested the mkfs command
100-200	-> tested the basic commands (like subvol *)
[...]

The idea is that a test xxx could use a command already tested in a test yyy 
(where xxx > yyy), knowing that he could not care if the command fail (of 
course this command is different from the object to test !!)




> +	${test}
> +done
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
