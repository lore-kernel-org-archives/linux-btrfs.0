From: David Nicol <davidnicol@gmail.com>
Subject: Re: IOCTL #21 part two: btrfs progs patch, including iso 8601 timeout support
Date: Thu, 7 Oct 2010 08:50:13 -0500
Message-ID: <AANLkTimGqfcdkQ_y_+z7Ch56fCWqXvwrtfE-vuncn5yP@mail.gmail.com>
References: <AANLkTim0NC5QRs_z=tA8R5R4J07aQ7LS-Ls17t2Qvd7p@mail.gmail.com> <201010070810.42505.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010070810.42505.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 7, 2010 at 1:10 AM, Goffredo Baroncelli <kreijack@libero.it=
> wrote:
> On Wednesday, 06 October, 2010, David Nicol wrote:
>> the ISO 8601 duration support is very loose, but I believe it is
>> accurate for valid

> In the man page and in the help the syntax is reported as:
>
> =C2=A0btrfs filesystem reclaim <path> [<timeout>]
>
> instead it should be
>
> =C2=A0btrfs filesystem reclaim [<path> [<timeout>]]
>
> and it has to be reported that path is optional and if it is omitted =
the
> current CWD is taken.

D'oh! yes you are right.



> 2) I think that it is more reasonable avoid a "strict" iso 8601 synta=
x for the
> time. I suggest to use a simple syntax like
>
> 0.xxxx -> subsecond
> s or nothing -> seconds
> m -> minutes
> h -> hour
> d -> day
> M -> month (but make sense to wait up to a month ?)
> [...]

That's what the function provides, aside from differentiating between
M and m instead of using the ISO8601 disambiguation rule (as explained
on wikipedia.) After sleeping on it I'm thinking that a better route
would be either

(1) having the timeout in seconds.subseconds and providing a separate
tool that will parse ISO8601 durations, which is suggested to invoke
in backticks. Greater reusability and fewer library functions linked
into the binaries for the win.

or

(2) only supporting the WDHMS designators, nothing larger, (not big-M
or Y), thus removing the ambiguity. Y or M before [TWDH] would be a
fatal error. No longer caring how many seconds in a year for the win.

> 3) As minor issue I have to point out that "reclaim" seems (to me) th=
at the
> user has to start this command in order to obtain more space, like if=
 this
> command starts a garbage collector. In any case the help/man page exp=
lain
> clearly the behavior of the command.

My hope is that the current behavior is a temporary stand-in for
something to be developed later that will more aggressively collect
garbage.


> + =C2=A0 =C2=A0 =C2=A0 switch (*endptr)
> + =C2=A0 =C2=A0 =C2=A0 {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 'P': /* anchor */ case 'p':
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ptr > P)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stde=
rr, "ignoring non-initial P "
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 "in ISO8601 duration string %s\n", P);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 'Y': /* years */ case 'y':
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 component *=3D 12;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BIGM:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* average days in a greg=
orian month */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 component *=3D (365.2425 =
/ 12.0);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* ms in a day */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 component *=3D ( 24 * 360=
0 * 1000 );
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ms +=3D component;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 'T': /* Time (not date) anch=
or */ case 't':
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 M_min =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 'W': /* week */ case 'w':
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 component *=3D 7;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 'D': /* day */ case 'd':
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 component *=3D =C2=A024 ;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 'H': /* hour */ case 'h':
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 component *=3D 60;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 M_min =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 'M': /* month, or minute */ =
case 'm':
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!M_min++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto BIGM;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 component *=3D 60;
> [...]
> In the function =C2=A0I suggest to avoid if possible a goto in a swit=
ch case. I
> think that it is more clear to repeat few lines instead of doing a go=
to.

Well it isn't a whole Duff's device, but by choosing to use the goto
here the constant of year length in seconds only has to appear once. I
guess I could define a symbol. Stacking the cases like this should cut
down on the number of jumps in the compiled machine code, as each
"break" in a switch is short for a jump to the end. I'd be okay with
testing nearer the top so the jump is forward instead of backwards.

I believe that having a goto in a switch statement with a lot of
fallthroughs in its logic (such as this one) highlights that a C
switch statement makes a jump table rather than being a macro for an
oddly crippled series of else-if statements referring to the same
topic, which is what some providers of switch syntax in certain other
languages like to do with the construct.

review: http://en.wikipedia.org/wiki/Duff's_device

and I'm trying to optimize for size, not speed.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
