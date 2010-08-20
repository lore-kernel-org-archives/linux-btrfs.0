From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [RFC] Move all btrfs command to only one command
Date: Fri, 20 Aug 2010 14:03:40 +0200
Message-ID: <201008201403.41330.kreijack@libero.it>
References: <AANLkTimyQAgs6Hkhsein_m6iXZMGXK-q6snRmR2V_h=o@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimyQAgs6Hkhsein_m6iXZMGXK-q6snRmR2V_h=o@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, 19 August, 2010, James Smith wrote:
> This patch randomizes the error codes and also fixes up some typos 
including
> capitalization in the output.
> 
> It would almost be nice to see a translation effort for the tool as well.
> 

Hi James,

I don't comment the changing the capitalization. Regarding the other changes:

[...]
 {
 	struct Command *cp;
 
-	printf("Usage:\n");
+	printf("VFS-2593 %s\n", BTRFS_BUILD_VERSION);
                ^^^^^^^^

What means VFS-2593 ?

+	printf("\nNo matter where you go, there you are.\n");

Is it really useful this kind of comment ?


[...]

+			fprintf(stderr, "ERR-A.11: in command '");

I am not against this kind of error codes, but I prefer

+			fprintf(stderr, "Error 'ERR-A.11' in command '");

And a file.txt which details the error codes (otherwise these errors are not 
very useful).

Why some error codes contain a dot (see ERR-C.13) and others not (like ERR-
A3) ?


Reagrds
G.Baroncelli

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) 
<kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
