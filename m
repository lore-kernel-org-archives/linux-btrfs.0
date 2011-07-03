From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: [PATCH 2/3] add btrfs-list.o as a seperate target
Date: Sun, 03 Jul 2011 21:13:01 +0200
Message-ID: <4E10BF3D.1040507@gmail.com>
References: <cover.1309560079.git.philipp.andreas@gmail.com> <a440a5ce963dd17cadf70cae05c9ceb661615f02.1309560079.git.philipp.andreas@gmail.com> <20110703184352.GA4325@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110703184352.GA4325@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Please ignore this patch. I found a more elegant solution just right now.
Thanks,
Andreas

On 03.07.2011 20:43, Hugo Mills wrote:
> On Sat, Jul 02, 2011 at 12:44:37AM +0200, Andreas Philipp wrote:
>> By adding btrfs-list.o as a seperate target which depends additionally
> separate
>
>> on version we can fix the following build error when invoking 'make
>> btrfs'.
>>
>> btrfs-list.c:37:21: error: version.h: No such file or directory
>> make: *** [btrfs-list.o] Error 1
>>
>> Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
>> ---
>> Makefile | 4 ++++
>> 1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 3a1e308..c60f9af 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -27,6 +27,10 @@ else
>> check=ls
>> endif
>>
>> +btrfs-list.o: version
>> + $(check) btrfs-list.c
>> + $(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c btrfs-list.c
>> +
>> .c.o:
>> $(check) $<
>> $(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
>
> This breaks the use of simple "make", as it just makes btrfs-list.o
> and nothing else. This new target should probably be put somewhere
> near the bottom of the file, not above the "all" target, where it
> becomes the default:
>
> hrm@ruthven:btrfs-progs-unstable $ make
> bash version.sh
> ls btrfs-list.c
> btrfs-list.c
> gcc -Wp,-MMD,./.btrfs-list.o.d,-MT,btrfs-list.o -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -g -Werror -Os -c btrfs-list.c
> hrm@ruthven:btrfs-progs-unstable $
>
> Hugo.
>
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJOEL88AAoJEJIcBJ3+XkgiAZ4QAIz+zHogJAs6Te/sxkttiItl
uudHpZJFiPDsD9jOrynewG9w3leKbde8pr9niB8fcDWwtdRp+z3k86CTNegVmkuv
75MkH5YEOjg8dVawaamjFLC0ENJMe/u3f3Ry982Ts7HDctCiABEfF4+XZ5dkrClk
igqNljcFrPS7s/X3lo3C9WNyJuPtdV1Woyy5a0u8d7NTsuLEDTq4jnup4zd6ObTd
MpQNNLb28rv2l9X9tRX2bRlneoSVtKdhb4tEAWG3miVyB3wDR+/9EJiGeYZlG52v
tXwbuTa8lngwJuVZsjhm+nzgJHVW3I6CXj13L4yxdQX8IKRQ+PrfR6HhEyO84Jim
IKdtKEsvI5sHucAiG26YuOSp6vnkiwebDsOmxnXsfr9EVcKlPQC7yYB1Akh7jMBe
BIy38RaB87nbI5m7ra4e+IGkl2stjZ7GdspjQg97wZI1WRdAu1NSsG6EbO05GZ3v
v/p4llrXH0Dl1ylygz9Prwkz9w5GVOpo88Ck0XOFtf8UrQJEMEMs8BwLu65prkmY
7L1srODGe+hpYLYEjBNL3iwACcLX5Yd80nHJBb+rdwLN8N3LXve6SxPw/pLgdty2
Su5o0AU39csp427OM1fExDbqphfsFhkK3SMOOGXS52Bed+iYXAzcJFGQ7c53l3vB
3qQ4EWe7LeX3gY6yd/EO
=JgSk
-----END PGP SIGNATURE-----

