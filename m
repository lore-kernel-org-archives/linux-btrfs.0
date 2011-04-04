From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: btrfs subvolume snapshot syntax too "smart"
Date: Mon, 4 Apr 2011 12:57:49 -0700
Message-ID: <BANLkTimbmwM078e-SVcuWPDqjy99_hV+sw@mail.gmail.com>
References: <BANLkTikvyUH2Dhm2p=N-GSzy7r4_nj=bNg@mail.gmail.com>
	<4D9A203E.9090807@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Goffredo Baroncelli <kreijack@libero.it>,
	"krzf83@gmail.com" <krzf83@gmail.com>, linux-btrfs@vger.kernel.org
To: kreijack@inwind.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D9A203E.9090807@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 4, 2011 at 12:47 PM, Goffredo Baroncelli <kreijack@libero.i=
t> wrote:
> On 04/04/2011 09:09 PM, krzf83@gmail.com wrote:
>> I understand btrfs intent but same command run twice should not give
>> diffrent results. This really makes snapshot automation hard
>>
>>
>> root@sv12 [/ssd]# btrfs subvolume snapshot /ssd/sub1 /ssd/5
>> Create a snapshot of '/ssd/sub1' in '/ssd/5'
>> root@sv12 [/ssd]# btrfs subvolume snapshot /ssd/sub1 /ssd/5
>> Create a snapshot of '/ssd/sub1' in '/ssd/5/sub1'
>> root@sv12 [/ssd]# btrfs subvolume snapshot /ssd/sub1 /ssd/5
>> Create a snapshot of '/ssd/sub1' in '/ssd/5/sub1'
>> ERROR: cannot snapshot '/ssd/sub1'
>
> The same is true for cp:
>
> # cp -rf /ssd/sub1 /ssd/5 =C2=A0 =C2=A0 =C2=A0 -> copy "sub1" as "5"
> # cp -rf /ssd/sub1 /ssd/5 =C2=A0 =C2=A0 =C2=A0 -> copy "sub1" in "5"
>
> However you are right. It could be fixed easily adding a switch like
> "--script", which force to handle the last part of the destination as
> the name of the subvolume, raising an error if it already exists.
>
> "subvolume snapshot" is the only command which suffers of this kind o=
f
> problem ?

Isn't this a situation where supporting a trailing / would help?

=46or example, with the / at the end, means "put the snapshot into the
folder".  Thus "btrfs subvolume snapshot /ssd/sub1 /ssd/5/" would
create a "sub1" snapshot inside the 5/ folder.  Running it a second
time would error out since /ssd/5/sub1/ already exists.  And if the 5/
folder doesn't exist, it would error out.

And without the / at the end, means "name the snapshot".  Thus "btrfs
subvolume snapshot /ssd/sub1 /ssd/5" would create a snapshot named
"/ssd/5".  Running the command again would error out due to the
snapshot already existing.  And if the 5/ folder doesn't exist, it's
created.  And it errors out if the 5/ folder already exists.

Or, something along those lines.  Similar to how other apps work
with/without a trailing /.

--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
