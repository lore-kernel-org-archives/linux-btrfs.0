From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: IOCTL #21 part two: btrfs progs patch, including iso 8601 timeout support
Date: Thu, 7 Oct 2010 08:10:42 +0200
Message-ID: <201010070810.42505.kreijack@libero.it>
References: <AANLkTim0NC5QRs_z=tA8R5R4J07aQ7LS-Ls17t2Qvd7p@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: David Nicol <davidnicol@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim0NC5QRs_z=tA8R5R4J07aQ7LS-Ls17t2Qvd7p@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, 06 October, 2010, David Nicol wrote:
> the ISO 8601 duration support is very loose, but I believe it is
> accurate for valid
> input. Without any non-numeric designators, the timeout is interpreted
> as seconds,
> so
>     btrfs fi reclaim 10.3321 /my_btrfs_mount ||  echo timed out
> will wait 10332 ms before echoing, if the pending subvolume deletions
> take longer than that.
> 
> Timeout defaults to 0, and path defaults to current directory.
> 

Please the next time put your patch inline or it is more difficult to 
highlight a suggestion.

Any way:

1)
[...]
+	{ do_wait4clean, 1002, /* require at most two args */
+	  "filesystem reclaim", "<path> [timeout]\n"
+		"Wait for cleanup of deleted subvolumes in the filesystem 
<path>.\n"
+		"Optional timeout in whole or partial seconds, or ISO8601 
string.\n"
+	},
[...]
+int do_wait4clean(int argc, char **argv)
+{
+	int fd, res;
+        struct btrfs_ioctl_cleaner_wait_args w4c_arg;
+
+	char	*path = ".";
+        w4c_arg.ms = 0UL;
+
+        if (argc > 1) 
+	     path = argv[1];
+        if (argc > 2) 
+             w4c_arg.ms = iso8601toms(argv[2]);
 
In the man page and in the help the syntax is reported as:

 btrfs filesystem reclaim <path> [<timeout>]

instead it should be

 btrfs filesystem reclaim [<path> [<timeout>]]

and it has to be reported that path is optional and if it is omitted the 
current CWD is taken.

2) I think that it is more reasonable avoid a "strict" iso 8601 syntax for the 
time. I suggest to use a simple syntax like

0.xxxx -> subsecond 
s or nothing -> seconds
m -> minutes
h -> hour
d -> day
M -> month (but make sense to wait up to a month ?)
[...]

3) As minor issue I have to point out that "reclaim" seems (to me) that the 
user has to start this command in order to obtain more space, like if this 
command starts a garbage collector. In any case the help/man page explain 
clearly the behavior of the command.

4)
[...]
+unsigned long iso8601toms(char *P){
+    unsigned long ms;
+    double component;
+    char *ptr;
+    char *endptr;
+    short M_min = 0;
+
+    ms = 0UL;
+    ptr = P;
+    for(;;){
+       component=strtod(ptr, &endptr);
+       switch (*endptr)
+       {
+          case 'P': /* anchor */ case 'p':
+             if (ptr > P)
+	         fprintf(stderr, "ignoring non-initial P "
+                         "in ISO8601 duration string %s\n", P);
+             break;
+          case 'Y': /* years */ case 'y':
+             component *= 12;
+          BIGM:
+             /* average days in a gregorian month */
+             component *= (365.2425 / 12.0);
+             /* ms in a day */
+             component *= ( 24 * 3600 * 1000 );
+             ms += component;
+             break;
+          case 'T': /* Time (not date) anchor */ case 't':
+             M_min = 1;
+             break;
+          case 'W': /* week */ case 'w':
+             component *= 7;
+          case 'D': /* day */ case 'd':
+             component *=  24 ;
+          case 'H': /* hour */ case 'h':
+             component *= 60;
+             M_min = 1;
+          case 'M': /* month, or minute */ case 'm':
+             if (!M_min++)
+                 goto BIGM;
+             component *= 60;
[...]
In the function  I suggest to avoid if possible a goto in a switch case. I 
think that it is more clear to repeat few lines instead of doing a goto.

Reagrds
G.Baroncelli


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
