Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:19487 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2JGOGC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2012 10:06:02 -0400
Message-ID: <50718C44.2080701@petaramesh.org>
Date: Sun, 07 Oct 2012 16:05:56 +0200
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, getting darn slower everyday
References: <50714AC8.4010100@petaramesh.org> (sfid-20121007_121057_935818_E179B3F4) <201210071259.05801.Martin@lichtvoll.de>
In-Reply-To: <201210071259.05801.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 07/10/2012 12:59, Martin Steigerwald a écrit :
> btrfs fi df (preferably with btrfs tools from Goffredo)
> btrfs fi show

I don't think I miss any free space ;-)

(From one of my machines, but the others have rather the same
architecture...)

# btrfs fi sh
failed to read /dev/sr0
Label: 'BTR_POOL'  uuid: 7266e630-ba72-404c-bfbd-759d3a6ce2e3
    Total devices 1 FS bytes used 278.55GB
    devid    1 size 912.26GB used 464.04GB path /dev/dm-1

Label: 'BTR_BOOT'  uuid: b280100e-6a9a-4488-a207-d4e3f001b4c9
    Total devices 1 FS bytes used 504.39MB
    devid    1 size 1.00GB used 729.50MB path /dev/sda2


# btrfs fi df /boot
System: total=4.00MB, used=4.00KB
Data+Metadata: total=725.50MB, used=504.38MB

# btrfs fi df /
Data: total=426.01GB, used=273.00GB
System, DUP: total=8.00MB, used=56.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=19.00GB, used=5.55GB
Metadata: total=8.00MB, used=0.00

# df -h /boot /
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2       1,1G  505M  517M  50% /boot
-               913G  285G  602G  33% /


...and I have quite a lot of snapshots, as I use OpenSuSE excellent
"snapper" utility :

# snapper list
Type   | #   | Pre # | Date                             | Cleanup       
| Description           | Userdata
-------+-----+-------+----------------------------------+----------------+-----------------------+---------
single | 0   |       |                                  |               
| current               |        
single | 33  |       | mer. 01 août 2012 09:17:01 CEST  | timeline      
| Precise               |        
pre    | 203 |       | lun. 27 août 2012 16:30:22 CEST  | empty-pre-post
| AvUp Precise->QuantA3 |        
post   | 213 | 203   | mar. 28 août 2012 10:15:02 CEST  | empty-pre-post
| ApUp Precise->QuantA3 |        
single | 265 |       | sam. 01 sept. 2012 08:17:02 CEST | timeline      
| QuantA3               |        
single | 443 |       | ven. 21 sept. 2012 00:17:02 CEST | timeline      
| QuantB1 K 3.5.0-15    |        
single | 456 |       | sam. 22 sept. 2012 11:17:01 CEST | timeline      
| timeline              |        
single | 463 |       | dim. 23 sept. 2012 10:17:03 CEST | timeline      
| QuantB1 K 3.5.0-15    |        
single | 473 |       | lun. 24 sept. 2012 00:17:01 CEST | timeline      
| QuantB1 K 3.5.0-15    |        
single | 486 |       | mar. 25 sept. 2012 08:17:01 CEST | timeline      
| QuantB1 K 3.5.0-15    |        
single | 495 |       | mer. 26 sept. 2012 09:17:11 CEST | timeline      
| QuantB1 K 3.5.0-15    |        
single | 505 |       | jeu. 27 sept. 2012 08:17:03 CEST | timeline      
| timeline              |        
single | 520 |       | ven. 28 sept. 2012 09:17:02 CEST | timeline      
| QuantB2 K 3.5.0-15    |        
single | 534 |       | sam. 29 sept. 2012 10:17:01 CEST | timeline      
| QuantB2 K 3.5.0-16    |        
single | 544 |       | dim. 30 sept. 2012 10:17:02 CEST | timeline      
| QuantB2 K 3.5.0-16    |        
single | 556 |       | lun. 01 oct. 2012 09:17:03 CEST  | timeline      
| QuantB2 K 3.5.0-16    |        
single | 568 |       | mar. 02 oct. 2012 08:17:01 CEST  | timeline      
| timeline              |        
single | 582 |       | mer. 03 oct. 2012 10:17:03 CEST  | timeline      
| timeline              |        
single | 591 |       | jeu. 04 oct. 2012 08:17:02 CEST  | timeline      
| timeline              |        
single | 602 |       | jeu. 04 oct. 2012 20:17:01 CEST  | timeline      
| timeline              |        
single | 603 |       | jeu. 04 oct. 2012 21:17:01 CEST  | timeline      
| timeline              |        
single | 604 |       | jeu. 04 oct. 2012 22:17:01 CEST  | timeline      
| timeline              |        
single | 605 |       | jeu. 04 oct. 2012 23:17:01 CEST  | timeline      
| timeline              |        
single | 608 |       | ven. 05 oct. 2012 10:17:04 CEST  | timeline      
| QuantB2 K 3.5.0-17    |        
single | 609 |       | ven. 05 oct. 2012 11:17:01 CEST  | timeline      
| timeline              |        
single | 610 |       | ven. 05 oct. 2012 12:17:02 CEST  | timeline      
| timeline              |        
single | 611 |       | ven. 05 oct. 2012 13:17:02 CEST  | timeline      
| timeline              |        
single | 612 |       | ven. 05 oct. 2012 14:17:01 CEST  | timeline      
| timeline              |        
single | 613 |       | ven. 05 oct. 2012 15:17:01 CEST  | timeline      
| timeline              |        
single | 614 |       | ven. 05 oct. 2012 19:17:02 CEST  | timeline      
| timeline              |        
single | 615 |       | ven. 05 oct. 2012 20:17:01 CEST  | timeline      
| timeline              |        
single | 616 |       | ven. 05 oct. 2012 22:18:48 CEST  | timeline      
| timeline              |        
single | 617 |       | ven. 05 oct. 2012 23:17:01 CEST  | timeline      
| timeline              |        
single | 618 |       | sam. 06 oct. 2012 10:17:03 CEST  | timeline      
| timeline              |        
single | 619 |       | sam. 06 oct. 2012 11:17:01 CEST  | timeline      
| timeline              |        
single | 620 |       | dim. 07 oct. 2012 00:17:03 CEST  | timeline      
| timeline              |        
single | 621 |       | dim. 07 oct. 2012 10:17:02 CEST  | timeline      
| timeline              |        
single | 622 |       | dim. 07 oct. 2012 11:17:02 CEST  | timeline      
| timeline              |        
single | 623 |       | dim. 07 oct. 2012 12:17:01 CEST  | timeline      
| timeline              |        
single | 624 |       | dim. 07 oct. 2012 13:17:01 CEST  | timeline      
| timeline              |        
single | 625 |       | dim. 07 oct. 2012 14:17:01 CEST  | timeline      
| timeline              |        
single | 626 |       | dim. 07 oct. 2012 15:17:01 CEST  | timeline      
| timeline              |

...or if you prefer, something like :

# btrfs su li /
ID 256 top level 5 path UBUNTU
ID 259 top level 5 path UBUNTU/@
ID 261 top level 5 path UBUNTU/@tmp
ID 262 top level 5 path UBUNTU/@home
ID 264 top level 5 path LMDE
ID 265 top level 5 path LMDE/@
ID 267 top level 5 path LMDE/@tmp
ID 268 top level 5 path LMDE/@home
ID 270 top level 5 path MINT
ID 271 top level 5 path MINT/@
ID 273 top level 5 path MINT/@tmp
ID 274 top level 5 path MINT/@home
ID 276 top level 5 path BODHI
ID 277 top level 5 path BODHI/@
ID 278 top level 5 path BODHI/@var
ID 279 top level 5 path BODHI/@tmp
ID 280 top level 5 path BODHI/@home
ID 282 top level 5 path STORAGE
ID 471 top level 5 path DATA/VBOX_HIDDEN
ID 472 top level 5 path DATA/VBOX_VMS
ID 505 top level 5 path LMDE/@/.snapshots
ID 506 top level 5 path LMDE/@home/.snapshots
ID 509 top level 5 path MINT/@/.snapshots
ID 510 top level 5 path MINT/@home/.snapshots
ID 515 top level 5 path UBUNTU/@/.snapshots
ID 516 top level 5 path UBUNTU/@home/.snapshots
ID 517 top level 5 path STORAGE/.snapshots
ID 628 top level 5 path DATA
ID 629 top level 5 path DATA/BIG
ID 630 top level 5 path DATA/BIG/michel
ID 1339 top level 5 path UBUNTU/@/.snapshots/33/snapshot
ID 1340 top level 5 path UBUNTU/@home/.snapshots/33/snapshot
ID 1341 top level 5 path STORAGE/.snapshots/35/snapshot
ID 1384 top level 5 path LMDE/@/.snapshots/2/snapshot
ID 1385 top level 5 path LMDE/@home/.snapshots/2/snapshot
ID 1387 top level 5 path MINT/@/.snapshots/2/snapshot
ID 1388 top level 5 path MINT/@home/.snapshots/2/snapshot
ID 1495 top level 5 path DATA/VBOX_HIDDEN/.snapshots
ID 1621 top level 5 path MINT/@/.snapshots/3/snapshot
ID 1622 top level 5 path MINT/@home/.snapshots/3/snapshot
ID 1651 top level 5 path MINT/@/.snapshots/4/snapshot
ID 1652 top level 5 path MINT/@home/.snapshots/4/snapshot
ID 1654 top level 5 path MINT/@/.snapshots/5/snapshot
ID 1655 top level 5 path MINT/@home/.snapshots/5/snapshot
ID 1657 top level 5 path MINT/@/.snapshots/6/snapshot
ID 1658 top level 5 path MINT/@home/.snapshots/6/snapshot
ID 1706 top level 5 path DATA/VBOX_HIDDEN/.snapshots/7/snapshot
ID 1874 top level 5 path UBUNTU/@home/.snapshots/203/snapshot
ID 1875 top level 5 path UBUNTU/@/.snapshots/203/snapshot
ID 1903 top level 5 path UBUNTU/@home/.snapshots/213/snapshot
ID 1904 top level 5 path UBUNTU/@/.snapshots/213/snapshot
ID 1980 top level 5 path LMDE/@/.snapshots/3/snapshot
ID 1981 top level 5 path LMDE/@home/.snapshots/3/snapshot
ID 1983 top level 5 path MINT/@/.snapshots/7/snapshot
ID 1984 top level 5 path MINT/@home/.snapshots/7/snapshot
ID 2058 top level 5 path UBUNTU/@/.snapshots/265/snapshot
ID 2059 top level 5 path UBUNTU/@home/.snapshots/263/snapshot
ID 2060 top level 5 path STORAGE/.snapshots/268/snapshot
ID 2184 top level 5 path LMDE/@/.snapshots/4/snapshot
ID 2185 top level 5 path LMDE/@home/.snapshots/4/snapshot
ID 2513 top level 5 path LMDE/@home/.snapshots/5/snapshot
ID 2514 top level 5 path LMDE/@/.snapshots/5/snapshot
ID 2515 top level 5 path LMDE/@/.snapshots/6/snapshot
ID 2516 top level 5 path LMDE/@home/.snapshots/6/snapshot
ID 2524 top level 5 path LMDE/@/.snapshots/9/snapshot
ID 2525 top level 5 path LMDE/@home/.snapshots/9/snapshot
ID 2527 top level 5 path LMDE/@/.snapshots/10/snapshot
ID 2528 top level 5 path LMDE/@home/.snapshots/10/snapshot
ID 2530 top level 5 path LMDE/@/.snapshots/11/snapshot
ID 2531 top level 5 path LMDE/@home/.snapshots/11/snapshot
ID 2533 top level 5 path LMDE/@/.snapshots/12/snapshot
ID 2534 top level 5 path LMDE/@home/.snapshots/12/snapshot
ID 2536 top level 5 path LMDE/@/.snapshots/13/snapshot
ID 2537 top level 5 path LMDE/@home/.snapshots/13/snapshot
ID 2539 top level 5 path LMDE/@/.snapshots/14/snapshot
ID 2540 top level 5 path LMDE/@home/.snapshots/14/snapshot
ID 2542 top level 5 path LMDE/@/.snapshots/15/snapshot
ID 2543 top level 5 path LMDE/@home/.snapshots/15/snapshot
ID 2545 top level 5 path LMDE/@/.snapshots/16/snapshot
ID 2546 top level 5 path LMDE/@home/.snapshots/16/snapshot
ID 2548 top level 5 path LMDE/@/.snapshots/17/snapshot
ID 2549 top level 5 path LMDE/@home/.snapshots/17/snapshot
ID 2551 top level 5 path LMDE/@/.snapshots/18/snapshot
ID 2552 top level 5 path LMDE/@home/.snapshots/18/snapshot
ID 2554 top level 5 path LMDE/@/.snapshots/19/snapshot
ID 2555 top level 5 path LMDE/@home/.snapshots/19/snapshot
ID 2557 top level 5 path LMDE/@/.snapshots/20/snapshot
ID 2558 top level 5 path LMDE/@home/.snapshots/20/snapshot
ID 2560 top level 5 path LMDE/@/.snapshots/21/snapshot
ID 2561 top level 5 path LMDE/@home/.snapshots/21/snapshot
ID 2563 top level 5 path LMDE/@/.snapshots/22/snapshot
ID 2564 top level 5 path LMDE/@home/.snapshots/22/snapshot
ID 2566 top level 5 path LMDE/@/.snapshots/23/snapshot
ID 2567 top level 5 path LMDE/@home/.snapshots/23/snapshot
ID 2569 top level 5 path LMDE/@/.snapshots/24/snapshot
ID 2570 top level 5 path LMDE/@home/.snapshots/24/snapshot
ID 2572 top level 5 path LMDE/@/.snapshots/25/snapshot
ID 2573 top level 5 path LMDE/@home/.snapshots/25/snapshot
ID 2575 top level 5 path LMDE/@/.snapshots/26/snapshot
ID 2576 top level 5 path LMDE/@home/.snapshots/26/snapshot
ID 2578 top level 5 path LMDE/@/.snapshots/27/snapshot
ID 2579 top level 5 path LMDE/@home/.snapshots/27/snapshot
ID 2581 top level 5 path LMDE/@/.snapshots/28/snapshot
ID 2582 top level 5 path LMDE/@home/.snapshots/28/snapshot
ID 2584 top level 5 path LMDE/@home/.snapshots/29/snapshot
ID 2585 top level 5 path LMDE/@/.snapshots/29/snapshot
ID 2586 top level 5 path LMDE/@/.snapshots/30/snapshot
ID 2587 top level 5 path LMDE/@home/.snapshots/30/snapshot
ID 2589 top level 5 path LMDE/@/.snapshots/31/snapshot
ID 2590 top level 5 path LMDE/@home/.snapshots/31/snapshot
ID 2676 top level 5 path UBUNTU/@/.snapshots/443/snapshot
ID 2677 top level 5 path UBUNTU/@home/.snapshots/442/snapshot
ID 2678 top level 5 path STORAGE/.snapshots/472/snapshot
ID 2682 top level 5 path MINT/@/.snapshots/8/snapshot
ID 2683 top level 5 path MINT/@home/.snapshots/8/snapshot
ID 2718 top level 5 path UBUNTU/@/.snapshots/456/snapshot
ID 2719 top level 5 path UBUNTU/@home/.snapshots/455/snapshot
ID 2720 top level 5 path STORAGE/.snapshots/486/snapshot
ID 2739 top level 5 path UBUNTU/@/.snapshots/463/snapshot
ID 2740 top level 5 path UBUNTU/@home/.snapshots/462/snapshot
ID 2741 top level 5 path STORAGE/.snapshots/493/snapshot
ID 2769 top level 5 path UBUNTU/@/.snapshots/473/snapshot
ID 2770 top level 5 path UBUNTU/@home/.snapshots/472/snapshot
ID 2771 top level 5 path STORAGE/.snapshots/503/snapshot
ID 2808 top level 5 path UBUNTU/@/.snapshots/486/snapshot
ID 2809 top level 5 path UBUNTU/@home/.snapshots/485/snapshot
ID 2810 top level 5 path STORAGE/.snapshots/516/snapshot
ID 2835 top level 5 path UBUNTU/@/.snapshots/495/snapshot
ID 2836 top level 5 path UBUNTU/@home/.snapshots/494/snapshot
ID 2837 top level 5 path STORAGE/.snapshots/525/snapshot
ID 2865 top level 5 path UBUNTU/@/.snapshots/505/snapshot
ID 2866 top level 5 path UBUNTU/@home/.snapshots/504/snapshot
ID 2867 top level 5 path STORAGE/.snapshots/535/snapshot
ID 2910 top level 5 path UBUNTU/@/.snapshots/520/snapshot
ID 2911 top level 5 path UBUNTU/@home/.snapshots/519/snapshot
ID 2912 top level 5 path STORAGE/.snapshots/550/snapshot
ID 2950 top level 5 path UBUNTU/@home/.snapshots/532/snapshot
ID 2951 top level 5 path STORAGE/.snapshots/563/snapshot
ID 2952 top level 5 path UBUNTU/@/.snapshots/534/snapshot
ID 2982 top level 5 path UBUNTU/@/.snapshots/544/snapshot
ID 2983 top level 5 path UBUNTU/@home/.snapshots/543/snapshot
ID 2984 top level 5 path STORAGE/.snapshots/574/snapshot
ID 3018 top level 5 path UBUNTU/@/.snapshots/556/snapshot
ID 3019 top level 5 path UBUNTU/@home/.snapshots/555/snapshot
ID 3020 top level 5 path STORAGE/.snapshots/586/snapshot
ID 3045 top level 5 path MINT/@/.snapshots/9/snapshot
ID 3046 top level 5 path MINT/@home/.snapshots/9/snapshot
ID 3060 top level 5 path UBUNTU/@/.snapshots/568/snapshot
ID 3061 top level 5 path UBUNTU/@home/.snapshots/567/snapshot
ID 3062 top level 5 path STORAGE/.snapshots/600/snapshot
ID 3069 top level 5 path LMDE/@/.snapshots/32/snapshot
ID 3070 top level 5 path LMDE/@home/.snapshots/32/snapshot
ID 3105 top level 5 path UBUNTU/@/.snapshots/582/snapshot
ID 3106 top level 5 path UBUNTU/@home/.snapshots/581/snapshot
ID 3107 top level 5 path STORAGE/.snapshots/615/snapshot
ID 3132 top level 5 path UBUNTU/@/.snapshots/591/snapshot
ID 3133 top level 5 path UBUNTU/@home/.snapshots/590/snapshot
ID 3134 top level 5 path STORAGE/.snapshots/624/snapshot
ID 3138 top level 5 path LMDE/@/.snapshots/33/snapshot
ID 3139 top level 5 path LMDE/@home/.snapshots/33/snapshot
ID 3168 top level 5 path UBUNTU/@/.snapshots/602/snapshot
ID 3169 top level 5 path UBUNTU/@home/.snapshots/601/snapshot
ID 3170 top level 5 path STORAGE/.snapshots/636/snapshot
ID 3171 top level 5 path UBUNTU/@/.snapshots/603/snapshot
ID 3172 top level 5 path UBUNTU/@home/.snapshots/602/snapshot
ID 3173 top level 5 path STORAGE/.snapshots/637/snapshot
ID 3174 top level 5 path UBUNTU/@/.snapshots/604/snapshot
ID 3175 top level 5 path UBUNTU/@home/.snapshots/603/snapshot
ID 3176 top level 5 path STORAGE/.snapshots/638/snapshot
ID 3177 top level 5 path UBUNTU/@/.snapshots/605/snapshot
ID 3178 top level 5 path UBUNTU/@home/.snapshots/604/snapshot
ID 3179 top level 5 path STORAGE/.snapshots/639/snapshot
ID 3186 top level 5 path UBUNTU/@/.snapshots/608/snapshot
ID 3187 top level 5 path UBUNTU/@home/.snapshots/607/snapshot
ID 3188 top level 5 path STORAGE/.snapshots/642/snapshot
ID 3189 top level 5 path UBUNTU/@/.snapshots/609/snapshot
ID 3190 top level 5 path UBUNTU/@home/.snapshots/608/snapshot
ID 3191 top level 5 path STORAGE/.snapshots/643/snapshot
ID 3192 top level 5 path UBUNTU/@/.snapshots/610/snapshot
ID 3193 top level 5 path UBUNTU/@home/.snapshots/609/snapshot
ID 3194 top level 5 path STORAGE/.snapshots/644/snapshot
ID 3195 top level 5 path UBUNTU/@/.snapshots/611/snapshot
ID 3196 top level 5 path UBUNTU/@home/.snapshots/610/snapshot
ID 3197 top level 5 path STORAGE/.snapshots/645/snapshot
ID 3198 top level 5 path UBUNTU/@/.snapshots/612/snapshot
ID 3199 top level 5 path UBUNTU/@home/.snapshots/611/snapshot
ID 3200 top level 5 path STORAGE/.snapshots/646/snapshot
ID 3201 top level 5 path UBUNTU/@/.snapshots/613/snapshot
ID 3202 top level 5 path UBUNTU/@home/.snapshots/612/snapshot
ID 3203 top level 5 path STORAGE/.snapshots/647/snapshot
ID 3204 top level 5 path UBUNTU/@/.snapshots/614/snapshot
ID 3205 top level 5 path UBUNTU/@home/.snapshots/613/snapshot
ID 3206 top level 5 path STORAGE/.snapshots/648/snapshot
ID 3207 top level 5 path UBUNTU/@/.snapshots/615/snapshot
ID 3208 top level 5 path UBUNTU/@home/.snapshots/614/snapshot
ID 3209 top level 5 path STORAGE/.snapshots/649/snapshot
ID 3210 top level 5 path UBUNTU/@/.snapshots/616/snapshot
ID 3211 top level 5 path UBUNTU/@home/.snapshots/615/snapshot
ID 3212 top level 5 path STORAGE/.snapshots/650/snapshot
ID 3213 top level 5 path UBUNTU/@/.snapshots/617/snapshot
ID 3214 top level 5 path UBUNTU/@home/.snapshots/616/snapshot
ID 3215 top level 5 path STORAGE/.snapshots/651/snapshot
ID 3216 top level 5 path UBUNTU/@/.snapshots/618/snapshot
ID 3217 top level 5 path UBUNTU/@home/.snapshots/617/snapshot
ID 3218 top level 5 path STORAGE/.snapshots/652/snapshot
ID 3219 top level 5 path UBUNTU/@/.snapshots/619/snapshot
ID 3220 top level 5 path UBUNTU/@home/.snapshots/618/snapshot
ID 3221 top level 5 path STORAGE/.snapshots/653/snapshot
ID 3222 top level 5 path UBUNTU/@/.snapshots/620/snapshot
ID 3223 top level 5 path UBUNTU/@home/.snapshots/619/snapshot
ID 3224 top level 5 path STORAGE/.snapshots/654/snapshot
ID 3225 top level 5 path UBUNTU/@/.snapshots/621/snapshot
ID 3226 top level 5 path UBUNTU/@home/.snapshots/620/snapshot
ID 3227 top level 5 path STORAGE/.snapshots/655/snapshot
ID 3228 top level 5 path UBUNTU/@/.snapshots/622/snapshot
ID 3229 top level 5 path UBUNTU/@home/.snapshots/621/snapshot
ID 3230 top level 5 path STORAGE/.snapshots/656/snapshot
ID 3231 top level 5 path UBUNTU/@/.snapshots/623/snapshot
ID 3232 top level 5 path UBUNTU/@home/.snapshots/622/snapshot
ID 3233 top level 5 path STORAGE/.snapshots/657/snapshot
ID 3234 top level 5 path UBUNTU/@/.snapshots/624/snapshot
ID 3235 top level 5 path UBUNTU/@home/.snapshots/623/snapshot
ID 3236 top level 5 path STORAGE/.snapshots/658/snapshot
ID 3237 top level 5 path UBUNTU/@/.snapshots/625/snapshot
ID 3238 top level 5 path UBUNTU/@home/.snapshots/624/snapshot
ID 3239 top level 5 path STORAGE/.snapshots/659/snapshot
ID 3240 top level 5 path UBUNTU/@/.snapshots/626/snapshot
ID 3241 top level 5 path UBUNTU/@home/.snapshots/625/snapshot
ID 3242 top level 5 path STORAGE/.snapshots/660/snapshot

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

