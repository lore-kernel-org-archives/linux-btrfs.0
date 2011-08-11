From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: [PATCH] Re: [btrfs-progs integration] incorrect argument	checking
 for "btrfs sub snap -r"
Date: Thu, 11 Aug 2011 08:45:40 +0200
Message-ID: <4E437A94.8030704@gmail.com>
References: <4E0BC7AA.7000709@cn.fujitsu.com> <chaz20110630084046.GC28702@seebyte.com> <4E0C3F72.5040508@gmail.com> <chaz20110630104340.GD28702@seebyte.com> <20110630105813.GD11170@carfax.org.uk> <chaz20110630123438.GE28702@seebyte.com> <4E0CE2B3.1080600@gmail.com> <chaz20110701082652.GF28702@seebyte.com> <4E0D9DCA.1090204@gmail.com> <20110701104223.GA7606@carfax.org.uk> <chaz20110701125536.GG28702@seebyte.com> <4E435AF8.2010408@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Hugo Mills <hugo@carfax.org.uk>,
	Stephane Chazelas <stephane.chazelas@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E435AF8.2010408@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
Hi,
 
You are right. Some time ago I have already sent a patch for this. Hugo,
can you please integrate it?
Thanks,
Andreas Philipp
 
[PATCH] check number of args for btrfs sub snap correctly
 
Check whether there are the right number of arguments (exatly 2 without
the flag -r) in the subcommand handler for the btrfs subvolume snapshot
command.
 
Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
- ---
 btrfs_cmds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
 
diff --git a/btrfs_cmds.c b/btrfs_cmds.c
index da5bd91..42c82f8 100644
- --- a/btrfs_cmds.c
+++ b/btrfs_cmds.c
@@ -354,7 +354,7 @@ int do_clone(int argc, char **argv)
             return 1;
         }
     }
- -    if (argc - optind < 2) {
+    if (argc - optind != 3) {
         fprintf(stderr, "Invalid arguments for subvolume snapshot\n");
         free(argv);
         return 1;
 
- --   
1.7.3.4
 
 
 
On 11.08.2011 06:30, Tsutomu Itoh wrote:     
> Hi, Hugo,
>
> I built your for-chris branch, and ran 'btrfs sub snap' command.
> Then, I encountered following error message.
>
> # btrfs sub snap Dir-1 Dir-2
> Invalid arguments for subvolume snapshot
>
> commit:8b4c2a22bff85f86af44587973c8da8c29a67ffc is wrong, I think.
>
> (2011/07/01 21:55), Stephane Chazelas wrote:
>> 2011-07-01 11:42:23 +0100, Hugo Mills:
>> [...]
>>>>> diff --git a/btrfs.c b/btrfs.c
>>>>> index e117172..b50c58a 100644
>>>>> --- a/btrfs.c
>>>>> +++ b/btrfs.c
>>>>> @@ -49,7 +49,7 @@ static struct Command commands[] = {
>>>>> /*
>>>>> avoid short commands different for the case only
>>>>> */
>>>>> - { do_clone, 2,
>>>>> + { do_clone, -2,
>>>>> "subvolume snapshot", "[-r] <source> [<dest>/]<name>\n"
>>>>> "Create a writable/readonly snapshot of the subvolume <source> with\n"
>>>>> "the name <name> in the <dest> directory.",
>>>>> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
>>>>> index 1d18c59..3415afc 100644
>>>>> --- a/btrfs_cmds.c
>>>>> +++ b/btrfs_cmds.c
>>>>> @@ -355,7 +355,7 @@ int do_clone(int argc, char **argv)
>>>>> return 1;
>>>>> }
>>>>> }
>>>>> - if (argc - optind < 2) {
>>>>> + if (argc - optind != 2) {
>>>>> fprintf(stderr, "Invalid arguments for subvolume snapshot\n");
>>>>> free(argv);
>>>>> return 1;
>>>>>
>>>> Thanks for having another look at this. You are perfectly right. Should
>>>> we patch my patch or should I rework a corrected version? What do you
>>>> think Hugo?
>>> Could you send a follow-up patch with just the second hunk, please?
>>> I screwed up the process with this (processing patches too quickly to
>>> catch the review), and I've already published the patch with the first
>>> hunk, above, into the for-chris branch.
>> Hugo, not sure what you mean nor whom you're talking to, but I
>> can certainly copy-paste the second hunk from above here:
>>
>> diff --git a/btrfs_cmds.c b/btrfs_cmds.c
>> index 1d18c59..3415afc 100644
>> --- a/btrfs_cmds.c
>> +++ b/btrfs_cmds.c
>> @@ -355,7 +355,7 @@ int do_clone(int argc, char **argv)
>> return 1;
>> }
>> }
>> - if (argc - optind < 2) {
>> + if (argc - optind != 2) {
> I think that '3' is correct.
>
> Thanks,
> Tsutomu
>
>> fprintf(stderr, "Invalid arguments for subvolume snapshot\n");
>> free(argv);
>> return 1;
>>
>> Cheers,
>> Stephane
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJOQ3qTAAoJEJIcBJ3+XkgiYTsP/jS8jZoQQoVzpLClfQ4+xIbh
T1DLiEsu92fy+vxRSEUiFpSUcNlv6qfczwlOwmzWpWk/Cs01RP/XzBPAQc8qqZDy
JcEHq1Iteix9r9f7kMw2kA2UuRXrtuEiKjAYAOzp8OFoWHLB+S8yV1ajsRa9THOX
wZ+8wUkNuBfNFjJmwtirNpU0XJwm2QHVAI9n+7jj9asNVedY5tt6vw0YtFVpy2zS
FxUmGVoo+9+BAEiYkpZ9uvtXUNLojTwyFjMwbH4QAzJWrLTrMhXlj+SRS52mKt9Z
+Sr71QcIdhy+bb4oBDCjwB1SV9qyAoHTUs1yETzNRPAUgdnX41gZ6q/FYBDplmwZ
wLNiIa5MjO63SMN32CzLPQn/WbCzWIuGFkoYaBPYQu1ig7xZ3GulCmzhOqWMRfLn
FcN9GKF/LDcjaey9eTtgrZSp+Q+lRgsHbgg/2aMjZiGMYjOq/+EcFWXA9JfHQqSo
anQJU9WyUd4eO0ZYFMdRYeH81/+U6UktQVViQF4G9KbV3lbu3WQHhbbdFe2i7FXH
hWhaUdSEd6JmdKQWgqlV5XWo0hgMLO04oP8S5V03zEH6n5J4YU1wHDpZvsZTQbe8
3+k0far4o48GbcjUrMeRBkEuJiMOjNIHBXhjx5IAWkFGAQXvU29VA0IJ/XLFKjLA
0RhnC+XwTuaMSTYDzdxP
=oQbK
-----END PGP SIGNATURE-----

