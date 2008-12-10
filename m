From: "Miguel Figueiredo Mascarenhas Sousa Filipe"
	<miguel.filipe@gmail.com>
Subject: Re: Selective Compression/Encryption
Date: Wed, 10 Dec 2008 12:19:40 +0000
Message-ID: <f058a9c30812100419v2c0645a5oc1f4691d88c21723@mail.gmail.com>
References: <20081209145952.GA30494@tux64-03>
	 <f058a9c30812090745v15b5f983u468b560ae791dc37@mail.gmail.com>
	 <gho2ao$d0q$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Jeremy Sanders" <jeremy@jeremysanders.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <gho2ao$d0q$1@ger.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 10, 2008 at 9:32 AM, Jeremy Sanders
<jeremy@jeremysanders.net> wrote:
> Miguel Figueiredo Mascarenhas Sousa Filipe wrote:
>
>> Things like compression or encription should be used at the "volume"
>> level. So.. if a user wants a specific set of files or dirs ..they should
>> create a mount-point/volume like:
>>
>> private_vol
>> bigarchives_vol
>
> Does a normal user have permissions to do this?
>
> I could easily see the case where a normal user has a set of very
> compressible files in a directory. They shouldn't have to get a sysadmin go
> to the trouble of setting this up.
>

that's a policy decision.
Distro's will probably allow a admin/wheel user to do such things.

Big deployments, shell servers, or university setups, will all have a
policy decision and usualy hack up costumised tools for managing users
quota, settings, passwds and things like that.

A costumised useradd would probably create such volumes for each user,
for instance, and a costumised passwd, would reencript stored data
with new passwd. (or something similar...)...
I know I did similar things when was a university sysadm, pam_useradd
and pam_mountd were heavily used and costumised.

Kind regards,


-- 
Miguel Sousa Filipe
